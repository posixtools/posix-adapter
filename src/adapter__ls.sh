#!/bin/sh
#==============================================================================
#   _
#  | |___
#  | / __|
#  | \__ \
#  |_|___/
#==============================================================================
# TOOL: LS
#==============================================================================

#==============================================================================
#
#  posix_adapter__ls [--all] [--almost-all] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'ls' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --all - ls compatible -a flag equivavelent.
#   --almost-all - ls compatible -A flag equivavelent.
# Arguments:
#   [1] path - Path that should be listed.
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
posix_adapter__ls() {
  posix_adapter__flag__all='0'
  posix_adapter__flag__almost_all='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --all)
        posix_adapter__flag__all='1'
        shift
        ;;
      --almost-all)
        posix_adapter__flag__almost_all='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__ls' \
          "Unexpected option '${1}'!" \
          'You can only use --all or --almost-all.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__ls' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$posix_adapter__flag__path" -eq '0' ]
        then
          posix_adapter__flag__path='1'
          posix_adapter__value__path="$1"
          shift
        else
          posix_adapter__report_invalid_parameters \
            'posix_adapter__ls' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__path" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__ls' \
      'Missing <path> argument!' \
      'To be able to use readlink, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,-- all
  # |,- almost_all
  # 00
  posix_adapter__decision="${posix_adapter__flag__all}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__almost_all}"

  _posix_adapter__ls__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__path"
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
#   [2] value_path - Path value.
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
_posix_adapter__ls__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,-- all
  # |,- almost_all
    00)
      ls \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,-- all
  # |,- almost_all
    01)
      ls \
        \
        -A \
        "$posix_adapter__value__path" \

      ;;
  # ,-- all
  # |,- almost_all
    10)
      ls \
        -a \
        \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__ls' \
        'Unexpected parameter combination!' \
        'You can only have --all or --almost-all.'
      ;;
  esac
}
