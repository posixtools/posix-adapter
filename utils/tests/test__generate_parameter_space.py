import re

import pytest

from utils.generate_parameter_space import Generator, GeneratorConfiguration


class TestGeneratorDocumentationParsing:
    def test__hashmark_can_be_recognized(self):
        config = GeneratorConfiguration()
        lines = [
            "# line_1",
            "other",
        ]
        config._parse_documentation(lines=lines)

        assert len(config.documentation) == 1
        assert config.documentation[0] == "# line_1"
        assert len(lines) == 1

    def test__indentation_is_tolerable(self):
        config = GeneratorConfiguration()
        lines = [
            "  # line_1",
            "other",
        ]
        config._parse_documentation(lines=lines)

        assert len(config.documentation) == 1
        assert config.documentation[0] == "  # line_1"
        assert len(lines) == 1

    def test__syntax_error(self):
        config = GeneratorConfiguration()
        lines = [
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_documentation(lines=lines)

        assert "documentation" in str(e.value)

        assert len(lines) == 1


class TestGeneratorParameterSpaceParsing:
    def test__details_can_be_parsed(self):
        config = GeneratorConfiguration()
        lines = [
            "  000000)",
            "other",
        ]
        config._parse_parameter_space(lines=lines)

        assert config.parameter_space__template == "  {combination:06b})"
        assert config.parameter_space__combination_template == "{combination:06b}"
        # 6 digit space means 2 ** 6 = 64 combinations.
        assert config.parameter_space__size == 64

        assert len(lines) == 1

    def test__any_numbers_are_acceptable(self):
        config = GeneratorConfiguration()
        lines = [
            "    123)",  # 4 spaces
            "other",
        ]
        config._parse_parameter_space(lines=lines)
        # 4 spaces here too
        assert config.parameter_space__template == "    {combination:03b})"
        assert config.parameter_space__combination_template == "{combination:03b}"
        assert config.parameter_space__size == 8

        assert len(lines) == 1

    def test__syntax_error(self):
        config = GeneratorConfiguration()
        lines = [
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_parameter_space(lines=lines)

        assert "parameter space" in str(e.value)

        assert len(lines) == 1


class TestGeneratorCommandParsing:
    def test__command_can_be_parsed(self):
        config = GeneratorConfiguration()
        lines = [
            "    command \\",
            "other",
        ]
        config._parse_command(lines=lines)

        assert config.command == "    command \\"

        assert len(lines) == 1

    def test__syntax_error(self):
        config = GeneratorConfiguration()
        lines = [
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_command(lines=lines)

        assert "command" in str(e.value)

        assert len(lines) == 1


class TestGeneratorParametersParsing:
    def test__parameters_can_be_parsed(self):
        config = GeneratorConfiguration()
        # Parameters with 2 space indentation.
        lines = [
            "  --argument_1 \\",
            "  --argument_2 \\",
            '  "$some_value" \\',
            "other",
        ]
        config._parse_parameters(lines=lines)

        assert len(config.parameters) == 3
        assert config.parameters[0] == "  --argument_1 \\"
        assert config.parameters[1] == "  --argument_2 \\"
        assert config.parameters[2] == '  "$some_value" \\'

        # Template indentation sohould be two spaces too.
        assert config.parameters__empty == "  \\"

        assert len(lines) == 1

    def test__syntax_error__no_parameter_defined(self):
        config = GeneratorConfiguration()
        lines = [
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_parameters(lines=lines)

        assert "parameter" in str(e.value)

        assert len(lines) == 1

    def test__syntax_error__inconsistent_indentation(self):
        config = GeneratorConfiguration()
        lines = [
            "   --argument_1 \\",
            "     --argument_2 \\",
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_parameters(lines=lines)

        assert "indentation" in str(e.value)

        assert len(lines) == 1


class TestGeneratorEmptyLineParsing:
    def test__empty_line_can_be_parsed(self):
        config = GeneratorConfiguration()
        lines = [
            "",
            "other",
        ]
        config._parse_empty_line(lines=lines)

        assert len(lines) == 1

    def test__whitespace_is_tolerable(self):
        config = GeneratorConfiguration()
        lines = [
            "    ",
            "other",
        ]
        config._parse_empty_line(lines=lines)

        assert len(lines) == 1

    def test__syntax_error(self):
        config = GeneratorConfiguration()
        lines = [
            "non empty",
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_empty_line(lines=lines)

        assert "empty" in str(e.value)

        assert len(lines) == 2


class TestGeneratorFooterParsing:
    def test__footer_can_be_parsed(self):
        config = GeneratorConfiguration()
        lines = [
            " ;;",
            "other",
        ]
        config._parse_footer(lines=lines)

        assert config.footer == " ;;"

        assert len(lines) == 1

    def test__syntax_error(self):
        config = GeneratorConfiguration()
        lines = [
            "non footer",
            "other",
        ]
        with pytest.raises(SyntaxError) as e:
            config._parse_footer(lines=lines)

        assert "footer" in str(e.value)

        assert len(lines) == 2


class TestGeneratorParsing:
    def test__success__full_input_can_be_parsed(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 value \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;;",
        ]
        config = GeneratorConfiguration.from_lines(lines=lines)

        assert config

        assert len(config.documentation) == 6
        assert config.documentation == lines[:6]

        assert config.parameter_space__size == 64
        assert config.parameter_space__template == "  {combination:06b})"
        assert config.parameter_space__combination_template == "{combination:06b}"

        assert config.command == lines[7]

        assert len(config.parameters) == 9
        assert config.parameters == lines[8:17]
        assert config.parameters__empty == "      \\"

        assert config.footer == lines[-1]

    def test__error__invalid_documentation_part(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "  |||,---- argument_4",  # Missing hashmark.
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;;",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        # The parser thinks that the line with the missing hashmark should be
        # the paramtere space line.
        assert "parameter space" in str(e.value)

    def test__error__invalid_parameter_space(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000",  # Missing trailing parenthesis.
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;;",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        assert "parameter space" in str(e.value)

    def test__error__invalid_command(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command ",  # Missing trailing slash.
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;;",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        assert "command" in str(e.value)

    def test__error__invalid_parameter(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6",  # Missing trailing slash.
            "      fixed_argument_3 \\",
            "",
            "    ;;",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        # The parser would think that the parameter with the missing trailing
        # slash will be the mandatory empty line.
        assert "empty" in str(e.value)

    def test__error__missing_mandatory_empty_line(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "    ;;",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        assert "empty" in str(e.value)

    def test__error__invalid_footer(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;",  # Only one semicolon.
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        assert "footer" in str(e.value)

    def test__error__additional_lines(self):
        lines = [
            "# ,------- argument_1",
            "# |,------ argument_2",
            "# ||,----- argument_3",
            "# |||,---- argument_4",
            "# ||||,--- argument_5",
            "# |||||,-- argument_6",
            "  000000)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "      --argument_3 \\",
            "      --argument_4 \\",
            "      --argument_5 \\",
            "      --argument_6 \\",
            "      fixed_argument_3 \\",
            "",
            "    ;;",
            "additional line",
        ]

        with pytest.raises(SyntaxError) as e:
            GeneratorConfiguration.from_lines(lines=lines)
        assert "additional" in str(e.value)


class TestGeneratorCases:
    def test__command_with_one_parameter_can_be_generated(self):
        lines = [
            "# ,-- argument_1",
            "  0)",
            "    command \\",
            "      --argument_1 \\",
            "",
            "    ;;",
        ]

        expected = [
            "# ,-- argument_1",
            "  0)",
            "    command \\",
            "      \\",
            "",
            "    ;;",
            "# ,-- argument_1",
            "  1)",
            "    command \\",
            "      --argument_1 \\",
            "",
            "    ;;",
        ]

        config = GeneratorConfiguration.from_lines(lines=lines)
        generator = Generator(config=config)

        result = [line for line in generator.generate_lines()]

        assert expected == result

    def test__command_with_two_parameters_can_be_generated(self):
        lines = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  00)",
            "    command \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "",
            "    ;;",
        ]

        expected = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  00)",
            "    command \\",
            "      \\",
            "      \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  01)",
            "    command \\",
            "      \\",
            "      --argument_2 \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  10)",
            "    command \\",
            "      --argument_1 \\",
            "      \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  11)",
            "    command \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "",
            "    ;;",
        ]

        config = GeneratorConfiguration.from_lines(lines=lines)
        generator = Generator(config=config)

        result = [line for line in generator.generate_lines()]

        assert expected == result

    def test__fixed_parameters_can_be_handled(self):
        lines = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  00)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      --argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_2 \\",
            "      fixed_argument_3 \\",
            "      fixed_argument_4 \\",
            "",
            "    ;;",
        ]

        expected = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  00)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      \\",
            "      fixed_argument_2 \\",
            "      \\",
            "      fixed_argument_3 \\",
            "      fixed_argument_4 \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  01)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      \\",
            "      fixed_argument_2 \\",
            "      --argument_2 \\",
            "      fixed_argument_3 \\",
            "      fixed_argument_4 \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  10)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      --argument_1 \\",
            "      fixed_argument_2 \\",
            "      \\",
            "      fixed_argument_3 \\",
            "      fixed_argument_4 \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  11)",
            "    command \\",
            "      fixed_argument_1 \\",
            "      --argument_1 \\",
            "      fixed_argument_2 \\",
            "      --argument_2 \\",
            "      fixed_argument_3 \\",
            "      fixed_argument_4 \\",
            "",
            "    ;;",
        ]

        config = GeneratorConfiguration.from_lines(lines=lines)

        # Fixed parameters should be added explicitly to the config. These
        # would be passed to the command az flags.
        config.fixed_indexes = [0, 2, 4, 5]

        generator = Generator(config=config)

        result = [line for line in generator.generate_lines()]

        assert expected == result

    def test__fixed_combinations_can_be_handled(self):
        lines = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  00)",
            "    command \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "",
            "    ;;",
        ]

        expected = [
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  01)",
            "    command \\",
            "      \\",
            "      --argument_2 \\",
            "",
            "    ;;",
            "# ,--- argument_1",
            "# |,-- argument_2",
            "  11)",
            "    command \\",
            "      --argument_1 \\",
            "      --argument_2 \\",
            "",
            "    ;;",
        ]

        config = GeneratorConfiguration.from_lines(lines=lines)

        # This pattern should lock the first bit to one, reducing the outputted
        # combinations.
        config.combination_pattern = re.compile(".1")

        generator = Generator(config=config)

        result = [line for line in generator.generate_lines()]

        assert expected == result
