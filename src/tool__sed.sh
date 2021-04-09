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
#  dm_tools__sed
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__sed() {
  dm_tools__flag__extended='0'

  dm_tools__flag__in_place='0'
  dm_tools__value__in_place_suffix=''

  dm_tools__flag__expression='0'
  dm_tools__value__expression=''

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --extended)
        dm_tools__flag__extended='1'
        shift
        ;;
      --in-place)
        dm_tools__flag__in_place='1'
        dm_tools__value__in_place_suffix="$2"
        shift
        shift
        ;;
      --expression)
        dm_tools__flag__expression='1'
        dm_tools__value__expression="$2"
        shift
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__sed' \
          "Unexpected option '${1}'!" \
          'You can only use --extended or --expression or --in-place.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__sed' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__path" -eq '0' ]
        then
          dm_tools__flag__path='1'
          dm_tools__value__path="$1"
          shift
        else
          dm_tools__error_details="$( \
            printf '%s' 'You have already passed a path argument, you '; \
            printf '%s' 'probably forgot the --expression flag before '; \
            printf '%s\n' 'your expression which is mandatory in dm_tools.' \
          )"
          dm_tools__report_invalid_parameters \
            'dm_tools__sed' \
            'Unexpected parameter!' \
            "$dm_tools__error_details"
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
  dm_tools__decision="${dm_tools__flag__extended}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__in_place}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__expression}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__path}"

  _dm_tools__sed__common \
    "$dm_tools__decision" \
    "$dm_tools__value__in_place_suffix" \
    "$dm_tools__value__expression" \
    "$dm_tools__value__path"
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
_dm_tools__sed__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__in_place_suffix="$2"
  dm_tools__value__expression="$3"
  dm_tools__value__path="$4"

  case "$dm_tools__decision_string" in
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0010)
      sed \
        \
        \
        -e "$dm_tools__value__expression" \
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
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0110)
      sed \
        \
        -i"$dm_tools__value__in_place_suffix" \
        -e "$dm_tools__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    0111)
      sed \
        \
        -i"$dm_tools__value__in_place_suffix" \
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1010)
      sed \
        -E \
        \
        -e "$dm_tools__value__expression" \
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
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1110)
      sed \
        -E \
        -i"$dm_tools__value__in_place_suffix" \
        -e "$dm_tools__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- in_place
  # ||,--- expression
  # |||,-- path
    1111)
      sed \
        -E \
        -i"$dm_tools__value__in_place_suffix" \
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__sed' \
        'Unexpected parameter combination!' \
        '--expression is mandatory, --extended and --in-place is optional'
      ;;
  esac
}
