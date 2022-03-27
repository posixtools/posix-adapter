#!/bin/sh
#==============================================================================
#            _
#   ___  ___| |__   ___
#  / _ \/ __| '_ \ / _ \
# |  __/ (__| | | | (_) |
#  \___|\___|_| |_|\___/
#==============================================================================
# TOOL: ECHO
#==============================================================================

#==============================================================================
#
#  posix_adapter__echo [--no-newline] <string>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'echo' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --no-newline - Flag that should prevent printing the trailing new line.
# Arguments:
#   [1] string - String that should be printed.
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
posix_adapter__echo() {
  posix_adapter__flag__no_newline='0'

  posix_adapter__value__string=''

  if [ "$#" -eq 0 ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__echo' \
      'Missing string parameter!' \
      'A singular <path> parameter was expected!'
  fi

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --no-newline)
        posix_adapter__flag__no_newline='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__echo' \
          "Unexpected option '${1}'!" \
          'Only --no-newline is available.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__echo' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        posix_adapter__value__string="$1"
        shift
        if [ "$#" -gt '0' ]
        then
          posix_adapter__report_invalid_parameters \
            'posix_adapter__echo' \
            'Unexpected parameter!' \
            'Multiple separated strings passed!'
        fi
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # ,-- no_newline
  # 0
  posix_adapter__decision="${posix_adapter__flag__no_newline}"

  _posix_adapter__echo__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__string"
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
#   [2] value_string -  String passed to the echo command.
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
_posix_adapter__echo__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__string="$2"

  case "$posix_adapter__decision_string" in
  # ,-- no_newline
    0)
      echo "$posix_adapter__value__string"
      ;;
  # ,-- no_newline
    1)
      printf '%s' "$posix_adapter__value__string"
      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__echo' \
        'Unexpected parameter combination!' \
        'You can only have the optional --no-newline option.'
      ;;
  esac
}
