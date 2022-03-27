#!/bin/sh
#==============================================================================
#   _
#  | |__   __ _ ___  ___ _ __   __ _ _ __ ___   ___
#  | '_ \ / _` / __|/ _ \ '_ \ / _` | '_ ` _ \ / _ \
#  | |_) | (_| \__ \  __/ | | | (_| | | | | | |  __/
#  |_.__/ \__,_|___/\___|_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: BASENAME
#==============================================================================

#==============================================================================
#
#  posix_adapter__basename <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'basename' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] path - Path from which the basename should be separated.
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
posix_adapter__basename() {
  if [ "$#" -eq 0 ]
  then
    # basename does not support the standard input by it's own, so helping it
    # out with xargs..
    xargs basename
  else
    if [ "$#" -gt 1 ]
    then
      posix_adapter__report_invalid_parameters \
        'posix_adapter__basename' \
        'Unexpected parameter count!' \
        "Only 1 parameter is expected, got ${#}!"
    fi

    case "$1" in
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__basename' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__basename' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
    esac

    basename "$1"
  fi
}
