#==============================================================================
#                  _             _   _
#   _ __ ___  __ _| |_ __   __ _| |_| |__
#  | '__/ _ \/ _` | | '_ \ / _` | __| '_ \
#  | | |  __/ (_| | | |_) | (_| | |_| | | |
#  |_|  \___|\__,_|_| .__/ \__,_|\__|_| |_|
#===================|_|========================================================
# TOOL: REALPATH
#==============================================================================
dm_tools__realpath() {
  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      realpath "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__realpath__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__readlink - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__realpath__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__no_symlink__present='0'

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --no-symlink)
        # Only a flag, no value assigned to it.
        dm_tools__no_symlink__present='1'
        shift
        ;;
      *)
        # We have to assume that the following params are only positional, as
        # this is the only way to be able to use the special "$@" expansion to
        # avoid using the eval command..
        # If we reach this point, we simply finish the parameter iteration.
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # 0
  # `-- no-symlink

  dm_tools__decision="${dm_tools__no_symlink__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    1)
      # Call with the --no-symlink flag.
      python -c \
        'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' \
        "$@"
      ;;
    0)
      # Regular call.
      python -c \
        'import os,sys; print(os.path.abspath(os.path.expanduser(sys.argv[1])))' \
        "$@"
      ;;
    *)
      >&2 echo "dm_tools__realpath - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

