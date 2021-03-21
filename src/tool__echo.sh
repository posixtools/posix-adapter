#==============================================================================
#            _
#   ___  ___| |__   ___
#  / _ \/ __| '_ \ / _ \
# |  __/ (__| | | | (_) |
#  \___|\___|_| |_|\___/
#==============================================================================
# TOOL: ECHO
#==============================================================================
dm_tools__echo() {
  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      echo "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__echo__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__echo - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__echo__darwin() {
  # Minimal implementation for the no newline parameter.
  if [ "$1" = '-n' ]
  then
    shift
    printf '%s' "$@"
  else
    echo "$@"
  fi
}

