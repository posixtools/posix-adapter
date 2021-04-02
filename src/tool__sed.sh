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
#  dm_tools__sed [--extended] [--expression <expression>] [<path>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'sed' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --extended - Use the extended regexp engine.
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
          'You can only use --extended or --expression.'
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
          dm_tools__report_invalid_parameters \
            'dm_tools__sed' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- extended
  # |,---- expression
  # ||,--- path
  # 000
  dm_tools__decision="${dm_tools__flag__extended}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__expression}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__path}"

  _dm_tools__sed__common \
    "$dm_tools__decision" \
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
#   [2] value_expression -  Value passed with the expression flag.
#   [3] value_path - Value for the positional path argument.
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
  dm_tools__value__expression="$2"
  dm_tools__value__path="$3"

  case "$dm_tools__decision_string" in
  # ,----- extended
  # |,---- expression
  # ||,--- path
    010)
      sed \
        \
        -e "$dm_tools__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- expression
  # ||,--- path
    011)
      sed \
        \
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
  # ,----- extended
  # |,---- expression
  # ||,--- path
    110)
      sed \
        -E \
        -e "$dm_tools__value__expression" \
        \

      ;;
  # ,----- extended
  # |,---- expression
  # ||,--- path
    111)
      sed \
        -E \
        -e "$dm_tools__value__expression" \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__sed' \
        'Unexpected parameter combination!' \
        '--expression is mandatory, --extended is optional'
      ;;
  esac
}
