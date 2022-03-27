#!/bin/sh
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
#  posix_adapter__date <format_string>
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__date() {
  if [ "$#" -eq 0 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__date' \
      'Missing parameter!' \
      'A singular <format> parameter was expected!'
  elif [ "$#" -ne 1 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__date' \
      'Unexpected parameter count!' \
      "Only 1 parameter is expected, got ${#}!"
  fi

  case "$1" in
    --[!-]*)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__date' \
        "Unexpected option '${1}'!" \
        'This function does not take options.'
      ;;
    -[!-]*)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__date' \
        "Invalid single dashed option '${1}'!" \
        "posix_adapter only uses double dashed options like '--option'."
      ;;
  esac

  date "$1"
}
