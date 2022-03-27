#!/bin/sh
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
#  posix_adapter__mkfifo <path>
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__mkfifo() {
  if [ "$#" -eq 0 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__mkfifo' \
      'Missing parameter!' \
      'A singular <path> parameter was expected!'
  elif [ "$#" -ne 1 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__mkfifo' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi

  case "$1" in
    --[!-]*)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__mkfifo' \
        "Unexpected option '${1}'!" \
        'This function does not take options.'
      ;;
    -[!-]*)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__mkfifo' \
        "Invalid single dashed option '${1}'!" \
        "posix_adapter only uses double dashed options like '--option'."
      ;;
  esac

  mkfifo "$1"
}
