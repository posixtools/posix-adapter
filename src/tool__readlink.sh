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
#  dm_tools__readlink [--canonicalize] <path>
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__readlink() {
  dm_tools__flag__canonicalize='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --canonicalize)
        dm_tools__flag__canonicalize='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__readlink' \
          "Unexpected option '${1}'!" \
          'You can only use --canonicalize.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__readlink' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__path" -eq '0' ]
        then
          dm_tools__flag__path='1'
          dm_tools__value__path="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__readlink' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__path" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__readlink' \
      'Missing <path> argument!' \
      'To be able to use readlink, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,-- canonicalize
  # 0
  dm_tools__decision="${dm_tools__flag__canonicalize}"

  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__readlink__linux \
        "$dm_tools__decision" \
        "$dm_tools__value__path"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__readlink__darwin \
        "$dm_tools__decision" \
        "$dm_tools__value__path"
      ;;

    *)
      dm_tools__report_incompatible_call 'dm_tools__mktemp'
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
_dm_tools__readlink__linux() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- canonicalize
    0)
      readlink \
        \
        "$dm_tools__value__path" \

      ;;
  # ,-- canonicalize
    1)
      readlink \
        -f \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__readlink' \
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
_dm_tools__readlink__darwin() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- canonicalize
    0)
      readlink \
        \
        "$dm_tools__value__path" \

      ;;
  # ,-- canonicalize
    1)
      if ! readlink -f "$dm_tools__value__path" 2>/dev/null
      then
        # Yep we are using python as a last resort..
        python -c \
          'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' \
          "$dm_tools__value__path"
      fi
      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__readlink' \
        'Unexpected parameter combination!' \
        'You can only have --canonicalize.'
      ;;
  esac
}
