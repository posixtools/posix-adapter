#==============================================================================
#             _    _
#   _ __ ___ | | _| |_ ___ _ __ ___  _ __
#  | '_ ` _ \| |/ / __/ _ \ '_ ` _ \| '_ \
#  | | | | | |   <| ||  __/ | | | | | |_) |
#  |_| |_| |_|_|\_\\__\___|_| |_| |_| .__/
#===================================|_|========================================
# TOOL: MKTEMP
#==============================================================================
dm_tools__mktemp() {
  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__mktemp__linux "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__mktemp__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__mktemp - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__mktemp__linux() {
  # Collecting the optional parameters and its values.
  dm_tools__directory__present='0'
  dm_tools__tmpdir__present='0'
  dm_tools__tmpdir__value=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --directory)
        dm_tools__directory__present='1'
        shift
        ;;
      --tmpdir)
        dm_tools__tmpdir__present='1'
        dm_tools__tmpdir__value="$2"
        shift
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # 00
  # |`--- tmpdif
  # `---- directory

  dm_tools__decision="${dm_tools__directory__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__tmpdir__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    00)
      mktemp
      ;;
    01)
      mktemp --tmpdir="${dm_tools__tmpdir__value}" "$@"
      ;;
    10)
      mktemp --directory "$@"
      ;;
    11)
      mktemp --directory --tmpdir="${dm_tools__tmpdir__value}" "$@"
      ;;
    *)
      >&2 echo "dm_tools__mktemp - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

_dm_tools__mktemp__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__directory__present='0'
  dm_tools__tmpdir__present='0'
  dm_tools__tmpdir__value=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --directory)
        dm_tools__directory__present='1'
        shift
        ;;
      --tmpdir)
        dm_tools__tmpdir__present='1'
        dm_tools__tmpdir__value="$2"
        shift
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # 00
  # |`--- tmpdif
  # `---- directory

  dm_tools__decision="${dm_tools__directory__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__tmpdir__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    00)
      mktemp
      ;;
    01)
      mktemp "${dm_tools__tmpdir__value}/${@}"
      ;;
    10)
      mktemp -d "$@"
      ;;
    11)
      mktemp -d "${dm_tools__tmpdir__value}/${@}"
      ;;
    *)
      >&2 echo "dm_tools__mktemp - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}
