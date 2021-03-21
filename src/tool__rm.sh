#==============================================================================
#
#   _ __ _ __ ___
#  | '__| '_ ` _ \
#  | |  | | | | | |
#  |_|  |_| |_| |_|
#==============================================================================
# TOOL: RM
#==============================================================================
dm_tools__rm() {
  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      rm "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__rm__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__rm - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__rm__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__recursive__present='0'
  dm_tools__force__present='0'

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --recursive)
        dm_tools__recursive__present='1'
        shift
        ;;
      --force)
        dm_tools__force__present='1'
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
  # 00
  # |`--- force
  # `---- recursive

  dm_tools__decision="${dm_tools__recursive__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__force__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    00)
      rm "$@"
      ;;
    01)
      rm -f "$@"
      ;;
    10)
      rm -r "$@"
      ;;
    11)
      rm -r -f "$@"
      ;;
    *)
      >&2 echo "dm_tools__rm - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

