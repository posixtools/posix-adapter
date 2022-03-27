#!/bin/sh
#==============================================================================
#
#   __       _     _
#  / _| ___ | | __| |
# | |_ / _ \| |/ _` |
# |  _| (_) | | (_| |
# |_|  \___/|_|\__,_|
#==============================================================================
# TOOL: FOLD
#==============================================================================

#==============================================================================
#
#  posix_adapter__fold [--spaces] --width <line_width>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'fold' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --spaces - Use the fold compatible -s flag to break at spaces
#   --width <line_width> - Use the fold compatible -w flag.
# Arguments:
#   None
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
posix_adapter__fold() {
  posix_adapter__flag__spaces='0'

  posix_adapter__flag__width='0'
  posix_adapter__value__width=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --spaces)
        posix_adapter__flag__spaces='1'
        shift
        ;;
      --width)
        posix_adapter__flag__width='1'
        posix_adapter__value__width="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__fold' \
          "Unexpected option '${1}'!" \
          'You can only use --spaces and --width.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__fold' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__fold' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- spaces
  # |,---- width
  # 00
  posix_adapter__decision="${posix_adapter__flag__spaces}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__width}"

  _posix_adapter__fold__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__width"
}

#==============================================================================
# Common based call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_width - Value for optional width parameter.
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
_posix_adapter__fold__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__width="$2"

  case "$posix_adapter__decision_string" in
  # ,----- spaces
  # |,---- width
    00)
      fold \
        \
        \

      ;;
  # ,----- spaces
  # |,---- width
    01)
      fold \
        \
        -w "$posix_adapter__value__width" \

      ;;
  # ,----- spaces
  # |,---- width
    10)
      fold \
        -s \
        \

      ;;
  # ,----- spaces
  # |,---- width
    11)
      fold \
        -s \
        -w "$posix_adapter__value__width" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__fold' \
        'Unexpected parameter combination!' \
        'You can only use --spaces and --width.'
      ;;
  esac
}

