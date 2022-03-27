#!/bin/sh
#==============================================================================
#      _ _
#   __| (_)_ __ _ __   __ _ _ __ ___   ___
#  / _` | | '__| '_ \ / _` | '_ ` _ \ / _ \
# | (_| | | |  | | | | (_| | | | | | |  __/
#  \__,_|_|_|  |_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: DIRNAME
#==============================================================================

#==============================================================================
#
#  posix_adapter__dirname <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'dirname' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] path - Path from which the directory name should be separated.
# STDIN:
#   Standard input can be used to pass a path.
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
posix_adapter__dirname() {
  if [ "$#" -eq 0 ]
  then
    # dirname does not support the standard input by it's own, so helping it
    # out with xargs..
    xargs dirname
  else
    if [ "$#" -gt 1 ]
    then
      posix_adapter__report_invalid_parameters \
        'posix_adapter__dirname' \
        'Unexpected parameter count!' \
        "Only 1 parameter is expected, got ${#}!"
    fi

    case "$1" in
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__dirname' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__dirname' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
    esac

    dirname "$1"
  fi
}
