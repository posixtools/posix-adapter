#!/bin/sh
#==============================================================================
#   _                   _
#  | |_ ___  _   _  ___| |__
#  | __/ _ \| | | |/ __| '_ \
#  | || (_) | |_| | (__| | | |
#   \__\___/ \__,_|\___|_| |_|
#==============================================================================
# TOOL: TOUCH
#==============================================================================

#==============================================================================
#
#  posix_adapter__touch <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'touch' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] path - Path that needs to be touched.
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
posix_adapter__touch() {
  if [ "$#" -eq 0 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__touch' \
      "Missing <path> parameter" \
      'This function does not take options.'
  elif [ "$#" -eq 1 ]
  then
    case "$1" in
    --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__touch' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
    -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__touch' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
    esac

    touch "$1"

  else
    posix_adapter__report_invalid_parameters \
      'posix_adapter__touch' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi
}
