#==============================================================================
#   _
#  | |_ _ __
#  | __| '__|
#  | |_| |
#   \__|_|
#==============================================================================
# TOOL: TR
#==============================================================================

#==============================================================================
#
#  dm_tools__tr [--delete <char>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'tr' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --delete <char> - tr compatible --delete flag.
# Arguments:
#   None
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
dm_tools__tr() {
  dm_tools__flag__delete='0'
  dm_tools__value__delete=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --delete)
        dm_tools__flag__delete='1'
        dm_tools__value__delete="$2"
        shift
        shift
        ;;
    --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__tr' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
    -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__tr' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__tr' \
          'Unexpected parameter!' \
          'Only options are available.'
        ;;
    esac
  done

  # Assembling the decision string.
  # ,-- delete
  # 0
  dm_tools__decision="${dm_tools__flag__delete}"

  _dm_tools__tr__common \
    "$dm_tools__decision" \
    "$dm_tools__value__delete"
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
#   [2] value_delete -  Value passed with the delete flag.
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
_dm_tools__tr__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__delete="$2"

  case "$dm_tools__decision_string" in
  # ,-- delete
    1)
      tr \
        --delete "$dm_tools__value__delete" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__tr' \
        'Unexpected parameter combination!' \
        'Only --delete is available.'
      ;;
  esac
}
