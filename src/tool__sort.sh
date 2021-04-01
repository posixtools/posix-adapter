#==============================================================================
#                  _
#   ___  ___  _ __| |_
#  / __|/ _ \| '__| __|
#  \__ \ (_) | |  | |_
#  |___/\___/|_|   \__|
#==============================================================================
# TOOL: SORT
#==============================================================================

#==============================================================================
#
#  dm_tools__sort [--zero-terminated] [--dictionary-order] [<path>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'sed' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --zero-terminated - Use the sort compatible -z flag.
#   --dictionary-order - Use the sort compatible -d flag.
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
dm_tools__sort() {
  dm_tools__flag__zero_terminated='0'
  dm_tools__flag__dictionary_order='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --zero-terminated)
        dm_tools__flag__zero_terminated='1'
        shift
        ;;
      --dictionary-order)
        dm_tools__flag__dictionary_order='1'
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__sort' \
          "Unexpected option '${1}'!" \
          'You can only use --zero-terminated or --dictionary-order.'
        ;;
      -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__sort' \
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
            'dm_tools__sort' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
  # 000
  dm_tools__decision="${dm_tools__flag__zero_terminated}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__dictionary_order}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__path}"

  _dm_tools__sort__common \
    "$dm_tools__decision" \
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
#   [2] value_path - Value for the positional path argument.
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
_dm_tools__sort__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    000)
      sort \
        \
        \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    001)
      sort \
        \
        \
        "$dm_tools__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    010)
      sort \
        \
        --dictionary-order \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    011)
      sort \
        \
        --dictionary-order \
        "$dm_tools__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    100)
      sort \
        --zero-terminated \
        \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    101)
      sort \
        --zero-terminated \
        \
        "$dm_tools__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    110)
      sort \
        --zero-terminated \
        --dictionary-order \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    111)
      sort \
        --zero-terminated \
        --dictionary-order \
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
