#!/bin/sh
#==============================================================================
#                _
#   ___  ___  __| |
#  / __|/ _ \/ _` |
#  \__ \  __/ (_| |
#  |___/\___|\__,_|
#==============================================================================
# TOOL: SED
#==============================================================================

#==============================================================================
#
#  posix_adapter__sed
#    [--extended]
#    [--in-place <suffix>]
#    [--expression <expression>]
#    [<path>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'sed' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --extended - Use the extended regexp engine.
#   --in-place <suffix> - In place processing with optional backup with suffix.
#   --expression <expression> - Expression that should be executed.
# Arguments:
#   [1] [path] - Optional file path.
# STDIN:
#   Input passed to the mapped command.
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Mapped command's output.
# STDERR:
#   Mapped command's error output. Mapping error output.
# Status:
#   0  - Call was successful.
#   .. - Call failed with it's error status
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__sed() {
  posix_adapter__flag__extended='0'

  posix_adapter__flag__in_place='0'
  posix_adapter__value__in_place_suffix=''

  posix_adapter__flag__expression='0'
  posix_adapter__value__expression=''

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --extended)
        posix_adapter__flag__extended='1'
        shift
        ;;
      --in-place)
        posix_adapter__flag__in_place='1'
        posix_adapter__value__in_place_suffix="$2"
        shift
        shift
        ;;
      --expression)
        posix_adapter__flag__expression='1'
        posix_adapter__value__expression="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__sed' \
          "Unexpected option '${1}'!" \
          'You can only use --extended or --expression or --in-place.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__sed' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$posix_adapter__flag__path" -eq '0' ]
        then
          posix_adapter__flag__path='1'
          posix_adapter__value__path="$1"
          shift
        else
          posix_adapter__error_details="$( \
            printf '%s' 'You have already passed a path argument, you '; \
            printf '%s' 'probably forgot the --expression flag before '; \
            printf '%s\n' 'your expression which is mandatory in posix_adapter.' \
          )"
          posix_adapter__report_invalid_parameters \
            'posix_adapter__sed' \
            'Unexpected parameter!' \
            "$posix_adapter__error_details"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
  # 0000
  posix_adapter__decision="${posix_adapter__flag__extended}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__in_place}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__expression}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__path}"

  _posix_adapter__sed__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__in_place_suffix" \
    "$posix_adapter__value__expression" \
    "$posix_adapter__value__path"
}

#==============================================================================
# Common call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_in_place_suffix - Value passed with the expression flag.
#   [3] value_expression - Value passed with the expression flag.
#   [4] value_path - Value for the positional path argument.
# STDIN:
#   Input passed to the mapped command.
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Mapped command's output.
# STDERR:
#   Mapped command's error output. Mapping error output.
# Status:
#   0  - Call succeeded.
#   .. - Call failed with it's error status
#==============================================================================
_posix_adapter__sed__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__in_place_suffix="$2"
  posix_adapter__value__expression="$3"
  posix_adapter__value__path="$4"

  case "$posix_adapter__decision_string" in
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0010)
      sed \
        \
        \
        -e "$posix_adapter__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0011)
      sed \
        \
        \
        -e "$posix_adapter__value__expression" \
        "$posix_adapter__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0110)
      sed \
        \
        -i"$posix_adapter__value__in_place_suffix" \
        -e "$posix_adapter__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0111)
      sed \
        \
        -i"$posix_adapter__value__in_place_suffix" \
        -e "$posix_adapter__value__expression" \
        "$posix_adapter__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1010)
      sed \
        -E \
        \
        -e "$posix_adapter__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1011)
      sed \
        -E \
        \
        -e "$posix_adapter__value__expression" \
        "$posix_adapter__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1110)
      sed \
        -E \
        -i"$posix_adapter__value__in_place_suffix" \
        -e "$posix_adapter__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1111)
      sed \
        -E \
        -i"$posix_adapter__value__in_place_suffix" \
        -e "$posix_adapter__value__expression" \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__sed' \
        'Unexpected parameter combination!' \
        '--expression is mandatory, --extended and --in-place is optional'
      ;;
  esac
}
