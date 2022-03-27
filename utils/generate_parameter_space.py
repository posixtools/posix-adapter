"""
Speedup tool for full parameter space generation. As posix_adapter does not use
the eval command to execute the mapped commands it needs to define all the
possible parameter combinations that can be executed. As these parameter
combinations can be pretty long an automated way is needed to aid the
development. The parameter combination selection is implemented as a shell
switch case statement. The decision is made with a binary decision string in
which each bit represents a possible argument to the given command.

Here is an example of a command parameter selection case with a big parameter
space:

  # ,------- argument_1
  # |,------ argument_2
  # ||,----- argument_3
  # |||,---- argument_4
  # ||||,--- argument_5
  # |||||,-- argument_6
    000000)
      command \
        fixed_argument_1 \
        fixed_argument_2 \
        --argument_1 \
        --argument_2 \
        --argument_3 \
        --argument_4 \
        --argument_5 \
        fixed_argument_3 \
        --argument_6 \

      ;;

It consist of 6 parts:

1. Documentation part

    The commented out visual decision string annotations. This is an important
    section because by looking at a plain decision string is often very
    confusing..

    Example:

    # ,------- argument_1
    # |,------ argument_2
    # ||,----- argument_3
    # |||,---- argument_4
    # ||||,--- argument_5
    # |||||,-- argument_6

2. Decision string

    The raw desicion string in a shell compatible case-esac case format.

    Example:

      000000)

3. Command

    The command that should be mapped with the parameter space.

    Example:

        command \

4. Parameters

    There are two kind of parameters: fixed and iterated. Fixed arguments
    should remain active in each parameter combination, while iterated
    parameters should be added or removed based on the current combination.

    The parameters should be added per-line basis with an empty
    new-line-escaped line representing a currently non-active iterated
    parameter to be able to provide an easy-to-validate visual representation
    of the given parameter set for a given parameter combination.

    Example:

          fixed_argument_1 \
          fixed_argument_2 \
          --argument_1 \
          --argument_2 \
          --argument_3 \
          --argument_4 \
          --argument_5 \
          fixed_argument_3 \
          --argument_6 \

5. Empty line

    An empty line to be able to use the line-break escapement slashes to have
    the options easily reviewable. Without this the parameters would needed to
    be concatenated into a single line, or the last parameter should not have
    the trailing escapement slash.

6. Case-esac construct enclosing semicolons

    Syntactically required closing semicolons.

This tool is intended to be used within vim by selecting the fully specified
parameter space case and filtering it through this script:

:'<,'>!python <path_to_this_script>

In this way vim will pass the selected section through the stdin file
descriptor of this sctipt, which should parse the input and provide all the
possible combinations to its standard output which vim will insert in place.
"""
import argparse
import re
import sys
from dataclasses import dataclass, field
from typing import Any
from typing import Generator as TypeGenerator
from typing import List, Optional


@dataclass
class GeneratorConfiguration:
    """
    Generator configuration parsed from the selected input text. It will
    provide all information about the parameter space generation.
    """

    # Bitwise explanation of the parameter space bits represented in a shell
    # compatible comment section.
    documentation: List[str] = field(default_factory=list)

    # Parameter space size derived from the bits in the input template.
    parameter_space__size: int = 0
    # Formatting template that should do the int -> case-esac case conversion.
    parameter_space__template: str = ""
    # Formatting template that should do the int -> binary string conversion.
    parameter_space__combination_template: str = ""

    # Raw command that is parsed from the input and simply pasted into the
    # generated items.
    command: str = ""

    # Parsed parameter list that contains all the parameters passd to the
    # input as a list.
    parameters: List[str] = field(default_factory=list)
    # Generated emty template based on the parameter section indentation. If an
    # iterable parameter is not active in the current combination, this
    # template will be inserted.
    parameters__empty: str = ""

    # Raw footer parsed from the input and simply pasted in to the generated
    # items.
    footer: str = ""

    # Externally set configuration that will set certain paramters as fixed
    # parameters excluding them from the parameter combination iteration. It is
    # expected to be a list of indexes in incrementing order.
    fixed_indexes: List[int] = field(default_factory=list)
    # Externally set configuration that will prevent any non matching
    # combination to be outputted. It should be a compiled regular expression
    # pattern, that should match binary decision strings. For example "...1."
    # will make the second bit fixed to one.
    combination_pattern: Optional[Any] = None
    # Externally set configuration that makes the combinations exclusive only.
    # i.e. for a three sized decision string: 001 010 100.
    exclusive: bool = False

    class Matchers:
        documentation = re.compile(r"^\s*#.*$")
        parameter_space = re.compile(r"^(\s*)(\d+)\)$")
        command = re.compile(r"^\s+[A-Za-z0-9_-]+\s*\\$")
        parameter = re.compile(r"^(\s+)[A-Za-z0-9_\-\=\$\'\"\s\{\}]+\s*\\$")
        empty_line = re.compile(r"^\s*$")
        footer = re.compile(r"^\s+;;$")

    class Errors:
        no_documentation = "No documentation was found for pattern '{pattern}'!"
        no_parameter_space = (
            "No parameter space definition was found for pattern '{pattern}'!"
        )
        no_command = "No command definition was found for pattern '{pattern}'!"
        no_parameters = "No parameter definition was found for pattern '{pattern}'!"
        inconsistent_parameter_indentations = "Parameter indentations are inconsistent!"
        no_empty_line = "No empty line was found for pattern '{pattern}'!"
        no_footer = "No footer definition was found for pattern '{pattern}'!"
        additional_lines = "Additional lines remained after parsing: {lines}"

    @classmethod
    def from_lines(cls, lines: List[str]):
        """
        Factory class method that will create the generator configuration based
        on the passed lines. It will call the parsers sequentially in the
        expected order. In case of error it will raise a SyntaxError.

        Each parser method should pop as many lines from the passed lines list
        as required. If there is no matching line at the 0th index it is a
        parsing error.

        At the end if there are any lines left in the input, that means there are
        additional content passed to the generator, which is also an error. It
        is an error because the generator will replace completely the passed
        selection.
        """

        config = cls()

        # Making a copy from the input lines.
        lines = list(lines)

        config._parse_documentation(lines=lines)
        config._parse_parameter_space(lines=lines)
        config._parse_command(lines=lines)
        config._parse_parameters(lines=lines)
        config._parse_empty_line(lines=lines)
        config._parse_footer(lines=lines)

        if lines:
            raise SyntaxError(cls.Errors.additional_lines.format(lines=lines))

        return config

    def _parse_documentation(self, lines):
        """
        Parser method for the documentation part. It should collect the
        commented out line that will be put back without modification before
        each case.

        Example:
        # ,------- argument_1
        # |,------ argument_2
        # ||,----- argument_3
        # |||,---- argument_4
        # ||||,--- argument_5
        # |||||,-- argument_6
        """
        while True:
            if self.Matchers.documentation.match(lines[0]):
                line = lines.pop(0)
                self.documentation.append(line)
            else:
                if not self.documentation:
                    raise SyntaxError(
                        self.Errors.no_documentation.format(
                            pattern=self.Matchers.documentation.pattern,
                        )
                    )
                break

    def _parse_parameter_space(self, lines):
        """
        Parser method for the parameter space. It has to determine the
        indentation and the size of the combinations it needs to be generated.

        Example:
          000000)
        """
        if m := self.Matchers.parameter_space.match(lines[0]):
            lines.pop(0)
            # The first capture group contains the indentation before the case
            # definition.
            indentation = m.group(1)
            # The second capture group captures all of the digits the input
            # contains.
            size = len(m.group(2))

            self.parameter_space__size = 2 ** size
            self.parameter_space__template = f"{indentation}{{combination:0{size}b}})"
            self.parameter_space__combination_template = f"{{combination:0{size}b}}"
        else:
            raise SyntaxError(
                self.Errors.no_parameter_space.format(
                    pattern=self.Matchers.parameter_space.pattern,
                )
            )

    def _parse_command(self, lines):
        """
        Parser method for the command part. It is only checks for the correct
        format and save the raw line.

        Example:
            command \\
        """
        pattern = self.Matchers.command
        if pattern.match(lines[0]):
            line = lines.pop(0)
            self.command = line
        else:
            raise SyntaxError(
                self.Errors.no_command.format(
                    pattern=pattern.pattern,
                )
            )

    def _parse_parameters(self, lines):
        """
        Parser function for the parameters defined for the command. This
        function is responsible for collecting all the parameters and
        generating an empty parameter template that should be used for the
        blank parameters later in the generation.

        Example:
              --argument_1 \
              --argument_2 \
        """
        pattern = self.Matchers.parameter
        indentation = None

        while True:
            if m := pattern.match(lines[0]):
                line = lines.pop(0)
                self.parameters.append(line)
                # The first and only group contains the indentation.
                temp_indentation = m.group(1)

                # Saving and validating the indentations.
                if indentation is None:
                    indentation = temp_indentation
                else:
                    if indentation != temp_indentation:
                        raise SyntaxError(
                            self.Errors.inconsistent_parameter_indentations
                        )
            else:
                # Preparing an empty paramter template that would be used for
                # currently unused paramter laceholder.
                self.parameters__empty = f"{indentation}\\"
                break

        if not self.parameters:
            raise SyntaxError(
                self.Errors.no_parameters.format(
                    pattern=pattern.pattern,
                )
            )

    def _parse_empty_line(self, lines):
        """
        Parser that should match and remove the necessary empty line.
        """
        pattern = self.Matchers.empty_line
        if pattern.match(lines[0]):
            lines.pop(0)
        else:
            raise SyntaxError(
                self.Errors.no_empty_line.format(
                    pattern=pattern.pattern,
                )
            )

    def _parse_footer(self, lines):
        pattern = self.Matchers.footer
        if pattern.match(lines[0]):
            line = lines.pop(0)
            self.footer = line
        else:
            raise SyntaxError(
                self.Errors.no_footer.format(
                    pattern=pattern.pattern,
                )
            )


class Generator:
    """
    Combination generation class that should generate and return lines for all
    the combinations based on the given configuration.
    """

    def __init__(self, config: GeneratorConfiguration):
        self._config = config

    def generate_lines(self) -> TypeGenerator[str, None, None]:
        """
        API method. Line-by-line generator for all the configured combinations.
        """
        for combination in range(self._config.parameter_space__size):
            if self._should_omit_current_combination(combination=combination):
                continue

            lines: List[str] = []

            self._fill_documentation_section(lines=lines)
            self._fill_current_combination_section(lines=lines, combination=combination)
            self._fill_command_section(lines=lines)
            self._fill_parameter_section(lines=lines, combination=combination)
            self._fill_empty_line_section(lines=lines)
            self._fill_footer_section(lines=lines)

            yield from lines

    def _should_omit_current_combination(self, combination: int) -> bool:
        """
        Function to determine if the current combination should be skipped or
        not. The decision is based on the externally set combination_pattern
        property. If the property is set only the matching combinations should
        be return False value i.e. only the matching combinations should be
        processed further.
        """
        combination_template = self._config.parameter_space__combination_template
        combination_string = combination_template.format(combination=combination)

        if self._config.exclusive:
            ones = combination_string.replace("0", "")
            if len(ones) > 1 or len(ones) == 0:
                return True

        if not self._config.combination_pattern:
            return False

        if self._config.combination_pattern.match(combination_string):
            return False
        else:
            return True

    def _fill_documentation_section(self, lines: list):
        """
        Adding the documentation part to the generated lines.
        """
        lines.extend(self._config.documentation)

    def _fill_current_combination_section(self, lines: list, combination: int):
        """
        Filling out the current combination number.
        """
        current_combination = self._config.parameter_space__template.format(
            combination=combination
        )
        lines.append(current_combination)

    def _fill_command_section(self, lines: list):
        """
        Adding the command section to the generated lines.
        """
        lines.append(self._config.command)

    def _fill_parameter_section(self, lines: list, combination: int):
        """
        Filling up the parameter section. Fixed parameters will also be
        handled. The output of this command is a fixed length parameter list
        that contains all the fixed parameters and the necessary non-fixed
        parameters for the given combination.
        """
        # The combination template contains a format string that will convert
        # the current combination number to the corresponding binary
        # representation in the correct width. Each bit in this form represents
        # a non-fixed parameter, and the value for that bit will control if the
        # given paramter should be included in the current combination or not.
        combination_template = self._config.parameter_space__combination_template
        # The combination values list contains an ordered list of True or False
        # values that indicate if the given non-fixed parameter should be
        # included or not in the current combination.
        combination_values = [
            value == "1"
            for value in combination_template.format(combination=combination)
        ]

        for index, parameter in enumerate(self._config.parameters):
            if index in self._config.fixed_indexes:
                lines.append(parameter)
            else:
                # If the first item in the combination values is True, then the
                # non-fixed parameter should be included in the current
                # combination.
                if combination_values.pop(0):
                    lines.append(parameter)
                else:
                    lines.append(self._config.parameters__empty)

    def _fill_empty_line_section(self, lines: list):
        """
        Adding the mandatory empty line to the generated lines.
        """
        lines.append("")

    def _fill_footer_section(self, lines: list):
        """
        Adding the footer section to the generated lines to complete a shell
        case-esac case definition.
        """
        lines.append(self._config.footer)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f",
        "--fixed-indexes",
        help="1-based comma separated list of fixed parameter indexes",
        type=str,
        default="",
    )
    parser.add_argument(
        "-p",
        "--combination-pattern",
        help="regular expression pattern to lock certain part of the combinations",
        type=str,
        default="",
    )
    parser.add_argument(
        "-e",
        "--exclusive",
        help="flag to make the possible combinations exclusive only. i.e. 001 010 100",
        action="store_true",
    )
    args = parser.parse_args()

    lines = [line.rstrip() for line in sys.stdin]

    # Converting the 1-based indexes into 0-based ones.
    if args.fixed_indexes:
        fixed_indexes = [int(index) - 1 for index in args.fixed_indexes.split(",")]
    else:
        fixed_indexes = []

    combination_pattern: Optional[Any]
    if args.combination_pattern:
        combination_pattern = re.compile(args.combination_pattern)
    else:
        combination_pattern = None

    try:
        config = GeneratorConfiguration.from_lines(lines=lines)
    except SyntaxError as e:
        print("SyntaxError during configuration parsing:")
        print(e)
        sys.exit(1)
    except Exception as e:
        print("Unexpected error happened during configuration parsing:")
        print(e)
        sys.exit(1)

    config.fixed_indexes = fixed_indexes
    config.combination_pattern = combination_pattern
    config.exclusive = args.exclusive

    generator = Generator(config=config)
    for line in generator.generate_lines():
        print(line)
