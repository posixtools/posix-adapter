#!/bin/sh
#==============================================================================
#                  _             _   _
#   _ __ ___  __ _| |_ __   __ _| |_| |__
#  | '__/ _ \/ _` | | '_ \ / _` | __| '_ \
#  | | |  __/ (_| | | |_) | (_| | |_| | | |
#  |_|  \___|\__,_|_| .__/ \__,_|\__|_| |_|
#===================|_|========================================================
# TOOL: REALPATH
#==============================================================================

#==============================================================================
#
#  posix_adapter__realpath [--no-symlinks] <target_path>
#  posix_adapter__realpath [--no-symlinks] --relative-to <path> <target_path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'realpath' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --no-symlinks - realpath compatible flag for the -s flag.
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
posix_adapter__realpath() {
  posix_adapter__flag__no_symlinks='0'

  posix_adapter__flag__relative_to='0'
  posix_adapter__value__relative_to=''

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --no-symlinks)
        posix_adapter__flag__no_symlinks='1'
        shift
        ;;
      --relative-to)
        posix_adapter__flag__relative_to='1'
        posix_adapter__value__relative_to="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__realpath' \
          "Unexpected option '${1}'!" \
          'You can only have --no-symlinks or --relative-to.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__realpath' \
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
            'posix_adapter__realpath' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__path" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__realpath' \
      'Missing <path> argument!' \
      'To be able to use realpath, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,--- no_symlinks
  # |,-- relative-to
  # 00
  posix_adapter__decision="${posix_adapter__flag__no_symlinks}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__relative_to}"

  case "$POSIX_ADAPTER__RUNTIME__OS" in

    "$POSIX_ADAPTER__CONSTANT__OS__LINUX")
      _posix_adapter__realpath__linux \
        "$posix_adapter__decision" \
        "$posix_adapter__value__relative_to" \
        "$posix_adapter__value__path"
      ;;

    "$POSIX_ADAPTER__CONSTANT__OS__MACOS")
      _posix_adapter__realpath__darwin \
        "$posix_adapter__decision" \
        "$posix_adapter__value__relative_to" \
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
#   [2] posix_adapter__value__relative_to - Path value.
#   [3] value_path - Path value.
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
_posix_adapter__realpath__linux() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__relative_to="$2"
  posix_adapter__value__path="$3"

  case "$posix_adapter__decision_string" in
  # ,--- no_symlinks
  # |,-- relative-to
    00)
      realpath \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    01)
      realpath \
        \
        --relative-to="$posix_adapter__value__relative_to" \
        "$posix_adapter__value__path" \

      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    10)
      realpath \
        -s \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    11)
      realpath \
        -s \
        --relative-to="$posix_adapter__value__relative_to" \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__realpath' \
        'Unexpected parameter combination!' \
        'You can only have --no-symlinks or --relative-to.'
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
#   [2] posix_adapter__value__relative_to - Path value.
#   [3] value_path - Path value.
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
_posix_adapter__realpath__darwin() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__relative_to="$2"
  posix_adapter__value__path="$3"

  case "$posix_adapter__decision_string" in
  # ,--- no_symlinks
  # |,-- relative-to
    00)
      if ! realpath "$posix_adapter__value__path" 2>/dev/null
      then
        python -c \
          'from os.path import expanduser,realpath;import sys;print(realpath(expanduser(sys.argv[1])))' \
          "$posix_adapter__value__path"
      fi
      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    01)
      if ! realpath --relative-to="$posix_adapter__value__relative_to" "$posix_adapter__value__path" 2>/dev/null
      then
        python -c \
          'from os.path import relpath,expanduser,realpath;import sys;print(relpath(realpath(expanduser(sys.argv[1])),realpath(expanduser(sys.argv[2]))))' \
          "$posix_adapter__value__path" "$posix_adapter__value__relative_to"
      fi
      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    10)
      if ! realpath -s "$posix_adapter__value__path" 2>/dev/null
      then
        python -c \
          'from os.path import expanduser,abspath;import sys;print(abspath(expanduser(sys.argv[1])))' \
          "$posix_adapter__value__path"
      fi
      ;;
  # ,--- no_symlinks
  # |,-- relative-to
    11)
      if ! realpath --relative-to="$posix_adapter__value__relative_to" "$posix_adapter__value__path" 2>/dev/null
      then
        python -c \
          'from os.path import relpath,expanduser,abspath;import sys;print(relpath(abspath(expanduser(sys.argv[1])),abspath(expanduser(sys.argv[2]))))' \
          "$posix_adapter__value__path" "$posix_adapter__value__relative_to"
      fi
      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__realpath' \
        'Unexpected parameter combination!' \
        'You can only have --no-symlinks or --relative-to.'
      ;;
  esac
}
