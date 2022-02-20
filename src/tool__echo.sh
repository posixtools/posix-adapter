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
#  dm_tools__echo [--no-newline] <string>
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__echo() {
  dm_tools__flag__no_newline='0'

  dm_tools__value__string=''

  if [ "$#" -eq 0 ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__echo' \
      'Missing string parameter!' \
      'A singular <path> parameter was expected!'
  fi

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --no-newline)
        dm_tools__flag__no_newline='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__echo' \
          "Unexpected option '${1}'!" \
          'Only --no-newline is available.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__echo' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__value__string="$1"
        shift
        if [ "$#" -gt '0' ]
        then
          dm_tools__report_invalid_parameters \
            'dm_tools__echo' \
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
  dm_tools__decision="${dm_tools__flag__no_newline}"

  _dm_tools__echo__common \
    "$dm_tools__decision" \
    "$dm_tools__value__string"
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
_dm_tools__echo__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__string="$2"

  case "$dm_tools__decision_string" in
  # ,-- no_newline
    0)
      echo "$dm_tools__value__string"
      ;;
  # ,-- no_newline
    1)
      printf '%s' "$dm_tools__value__string"
      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__echo' \
        'Unexpected parameter combination!' \
        'You can only have the optional --no-newline option.'
      ;;
  esac
}
