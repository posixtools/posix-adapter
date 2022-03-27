#!/bin/sh
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
#  posix_adapter__cat [path]
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__cat() {
  if [ "$#" -eq 0 ]
  then
    cat
  elif [ "$#" -eq 1 ]
  then
    case "$1" in
    --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__cat' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
    -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__cat' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
    esac

    cat "$1"
  else
    posix_adapter__report_invalid_parameters \
      'posix_adapter__cat' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi
}
