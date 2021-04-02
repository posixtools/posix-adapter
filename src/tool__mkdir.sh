#==============================================================================
#             _       _ _
#   _ __ ___ | | ____| (_)_ __
#  | '_ ` _ \| |/ / _` | | '__|
#  | | | | | |   < (_| | | |
#  |_| |_| |_|_|\_\__,_|_|_|
#==============================================================================
# TOOL: MKDIR
#==============================================================================

#==============================================================================
#
#  dm_tools__mkdir [--parents] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'mkdir' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --parents - mkdir compatible alias for the -p flag.
# Arguments:
#   [1] path - Path that should be created.
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
dm_tools__mkdir() {
  dm_tools__flag__parents='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --parents)
        dm_tools__flag__parents='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__mkdir' \
          "Unexpected option '${1}'!" \
          'You can only use --parents.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__mkdir' \
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
            'dm_tools__mkdir' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__path" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__mkdir' \
      'Missing <path> argument!' \
      'A directory can only be createdif you pass a path for it.'
  fi

  # Assembling the decision string.
  # ,-- parents
  # 0
  dm_tools__decision="${dm_tools__flag__parents}"

  _dm_tools__mkdir__common \
    "$dm_tools__decision" \
    "$dm_tools__value__path"
}

#==============================================================================
# Common call mapping function
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_path - Path for the mkdir command.
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
_dm_tools__mkdir__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- parents
    0)
      mkdir \
        \
        "$dm_tools__value__path" \

      ;;
  # ,-- parents
    1)
      mkdir \
        -p \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__mkdir' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
