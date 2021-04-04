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
#  dm_tools__tr [--delete <char>] [--replace <target> <value>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'tr' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --delete <char> - tr compatible --delete flag.
#   --replace <target> <value> - Default tr functionality put behind an option
#                                to make it more explicit.
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

  dm_tools__flag__replace='0'
  dm_tools__value__replace__target=''
  dm_tools__value__replace__value=''

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
      --replace)
        dm_tools__flag__replace='1'
        dm_tools__value__replace__target="$2"
        dm_tools__value__replace__value="$3"
        shift
        shift
        shift
        ;;
    --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__tr' \
          "Unexpected option '${1}'!" \
          'Only --delete or --replace is available.'
        ;;
    -[!-]*)
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
  # ,--- delete
  # |,-- replace
  # 00
  dm_tools__decision="${dm_tools__flag__delete}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__replace}"

  _dm_tools__tr__common \
    "$dm_tools__decision" \
    "$dm_tools__value__delete" \
    "$dm_tools__value__replace__target" \
    "$dm_tools__value__replace__value"
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
#   [2] value_delete -  Value passed with the delete option.
#   [3] value_replace_target -  Target value passed with the replace option.
#   [4] value_replace_value -  Value passed with the replace option.
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
  dm_tools__value__replace__target="$3"
  dm_tools__value__replace__value="$4"

  case "$dm_tools__decision_string" in
  # ,--- delete
  # |,-- replace
    01)
      tr \
        \
        "$dm_tools__value__replace__target" "$dm_tools__value__replace__value" \

      ;;
  # ,--- delete
  # |,-- replace
    10)
      tr \
        -d "$dm_tools__value__delete" \
        \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__tr' \
        'Unexpected parameter combination!' \
        'Only --delete or --replace is available.'
      ;;
  esac
}
