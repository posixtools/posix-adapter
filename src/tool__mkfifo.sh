#==============================================================================
#             _     __ _  __
#   _ __ ___ | | __/ _(_)/ _| ___
#  | '_ ` _ \| |/ / |_| | |_ / _ \
#  | | | | | |   <|  _| |  _| (_) |
#  |_| |_| |_|_|\_\_| |_|_|  \___/
#==============================================================================
# TOOL: MKFIFO
#==============================================================================

#==============================================================================
#
#  dm_tools__mkfifo <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'mkfifo' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] path - Path for the fifo.
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
dm_tools__mkfifo() {
  if [ "$#" -eq 0 ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__mkfifo' \
      'Missing parameter!' \
      'A singular <path> parameter was expected!'
  elif [ "$#" -ne 1 ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__mkfifo' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi

  case "$1" in
    --[!-]*)
      dm_tools__report_invalid_parameters \
        'dm_tools__mkfifo' \
        "Unexpected option '${1}'!" \
        'This function does not take options.'
      ;;
    -[!-]*)
      dm_tools__report_invalid_parameters \
        'dm_tools__mkfifo' \
        "Invalid single dashed option '${1}'!" \
        "dm_tools only uses double dashed options like '--option'."
      ;;
  esac

  mkfifo "$1"
}
