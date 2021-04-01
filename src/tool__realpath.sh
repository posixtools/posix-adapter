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
#  dm_tools__realpath [--no-symlink] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'realpath' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --no-symlink - realpath compatible flag for the -s flag.
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
dm_tools__realpath() {
  dm_tools__flag__no_symlink='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --no-symlink)
        dm_tools__flag__no_symlink='1'
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__realpath' \
          "Unexpected option '${1}'!" \
          'You can only use --no-symlink.'
        ;;
      -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__realpath' \
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
            'dm_tools__realpath' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__path" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__realpath' \
      'Missing <path> argument!' \
      'To be able to use realpath, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,-- no_symlink
  # 0
  dm_tools__decision="${dm_tools__flag__no_symlink}"

  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__realpath__linux \
        "$dm_tools__decision" \
        "$dm_tools__value__path"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__realpath__darwin \
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
_dm_tools__realpath__linux() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- no_symlink
    0)
      realpath \
        \
        "$dm_tools__value__path" \

      ;;
  # ,-- no_symlink
    1)
      realpath \
        -s \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__realpath' \
        'Unexpected parameter combination!' \
        'You can only have --no-symlink.'
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
_dm_tools__realpath__darwin() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- no-symlink
    0)
      if ! realpath "$dm_tools__value__path" 2>/dev/null
      then
        # Using python as a last resort..
        python -c \
          'import os,sys; print(os.path.abspath(os.path.expanduser(sys.argv[1])))' \
          "$dm_tools__value__path"
      fi
      ;;
  # ,-- no-symlink
    1)
      if ! realpath -s "$dm_tools__value__path" 2>/dev/null
      then
        # Using python as a last resort..
        python -c \
          'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' \
          "$dm_tools__value__path"
      fi
      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__readlink' \
        'Unexpected parameter combination!' \
        'You can only have --no-symlink.'
      ;;
  esac
}
