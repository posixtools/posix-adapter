#==============================================================================
#      _       _
#   __| | __ _| |_ ___
#  / _` |/ _` | __/ _ \
# | (_| | (_| | ||  __/
#  \__,_|\__,_|\__\___|
#==============================================================================
# TOOL: DATE
#==============================================================================

#==============================================================================
#
#  dm_tools__date <format_string>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'date' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] format_string - Format string the date should be generated from.
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
dm_tools__date() {
  if [ "$#" -eq 0 ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__date' \
      'Missing parameter!' \
      'A singular <format> parameter was expected!'
  elif [ "$#" -ne 1 ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__date' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi

  case "$1" in
    --[!-]*)
      dm_tools__report_invalid_parameters \
        'dm_tools__date' \
        "Unexpected option '${1}'!" \
        'This function does not take options.'
      ;;
    -[!-]*)
      dm_tools__report_invalid_parameters \
        'dm_tools__date' \
        "Invalid single dashed option '${1}'!" \
        "dm_tools only uses double dashed options like '--option'."
      ;;
  esac

  date "$1"
}
