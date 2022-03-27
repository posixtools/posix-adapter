#!/bin/sh
#==============================================================================
#                      _ _ _       _
#   _ __ ___  __ _  __| | (_)_ __ | | __
#  | '__/ _ \/ _` |/ _` | | | '_ \| |/ /
#  | | |  __/ (_| | (_| | | | | | |   <
#  |_|  \___|\__,_|\__,_|_|_|_| |_|_|\_\
#==============================================================================
# TOOL: READLINK
#==============================================================================

#==============================================================================
#
#  posix_adapter__readlink [--canonicalize] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'readlink' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --canonicalize - readlink compatible flag for the original -f flag.
# Arguments:
#   [1] path - Path that should be resolved.
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
posix_adapter__readlink() {
  posix_adapter__flag__canonicalize='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --canonicalize)
        posix_adapter__flag__canonicalize='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__readlink' \
          "Unexpected option '${1}'!" \
          'You can only use --canonicalize.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__readlink' \
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
            'posix_adapter__readlink' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__path" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__readlink' \
      'Missing <path> argument!' \
      'To be able to use readlink, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,-- canonicalize
  # 0
  posix_adapter__decision="${posix_adapter__flag__canonicalize}"

  case "$POSIX_ADAPTER__RUNTIME__OS" in

    "$POSIX_ADAPTER__CONSTANT__OS__LINUX")
      _posix_adapter__readlink__linux \
        "$posix_adapter__decision" \
        "$posix_adapter__value__path"
      ;;

    "$POSIX_ADAPTER__CONSTANT__OS__MACOS")
      _posix_adapter__readlink__darwin \
        "$posix_adapter__decision" \
        "$posix_adapter__value__path"
      ;;

    *)
      posix_adapter__report_incompatible_call 'posix_adapter__mktemp'
      ;;
  esac
}

#==============================================================================
# Linux based call mapping function.
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
_posix_adapter__readlink__linux() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,-- canonicalize
    0)
      readlink \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,-- canonicalize
    1)
      readlink \
        -f \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__readlink' \
        'Unexpected parameter combination!' \
        'You can only have --canonicalize.'
      ;;
  esac
}

#==============================================================================
# Darwin based call mapping function.
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
_posix_adapter__readlink__darwin() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,-- canonicalize
    0)
      readlink \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,-- canonicalize
    1)
      if ! readlink -f "$posix_adapter__value__path" 2>/dev/null
      then
        # Yep we are using python as a last resort..
        python -c \
          'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' \
          "$posix_adapter__value__path"
      fi
      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__readlink' \
        'Unexpected parameter combination!' \
        'You can only have --canonicalize.'
      ;;
  esac
}
