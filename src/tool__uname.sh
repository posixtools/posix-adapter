#==============================================================================
#
#  _   _ _ __   __ _ _ __ ___   ___
# | | | | '_ \ / _` | '_ ` _ \ / _ \
# | |_| | | | | (_| | | | | | |  __/
#  \__,_|_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: UNAME
#==============================================================================
dm_tools__uname() {
  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      uname "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__uname__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__uname - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__uname__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__kernel_name__present='0'
  dm_tools__kernel_release__present='0'
  dm_tools__machine__present='0'

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --kernel-name)
        dm_tools__kernel_name__present='1'
        shift
        ;;
      --kernel-release)
        dm_tools__kernel_release__present='1'
        shift
        ;;
      --machine)
        dm_tools__machine__present='1'
        shift
        ;;
      *)
        >&2 echo "dm_tools__uname - Unexpected parameter: '${dm_tools__param}'"
        exit 1
        ;;
    esac
  done

  # Assembling the decision string.
  # 000
  # ||`-- machine
  # |`--- kernel-release
  # `---- kernel_name

  dm_tools__decision="${dm_tools__kernel_name__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__kernel_release__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__machine__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    000)
      uname
      ;;
    001)
      uname       -m
      ;;
    010)
      uname    -r
      ;;
    011)
      uname    -r -m
      ;;
    100)
      uname -s
      ;;
    101)
      uname -s    -m
      ;;
    110)
      uname -s -r
      ;;
    111)
      uname -s -r -m
      ;;
    *)
      >&2 echo "dm_tools__uname - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

