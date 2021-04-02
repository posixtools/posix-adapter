#==============================================================================
#            _
#   ___ __ _| |_
#  / __/ _` | __|
# | (_| (_| | |_
#  \___\__,_|\__|
#==============================================================================
# TOOL: CAT
#==============================================================================

#==============================================================================
#
#  dm_tools__cat [path]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'cat' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] [path] - Path that's content should be printed out.
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
dm_tools__cat() {
  if [ "$#" -eq 0 ]
  then
    cat
  elif [ "$#" -eq 1 ]
  then
    case "$1" in
    --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__cat' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
    -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__cat' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
    esac

    cat "$1"
  else
    dm_tools__report_invalid_parameters \
      'dm_tools__cat' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi
}
