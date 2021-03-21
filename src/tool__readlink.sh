#==============================================================================
#                      _ _ _       _
#   _ __ ___  __ _  __| | (_)_ __ | | __
#  | '__/ _ \/ _` |/ _` | | | '_ \| |/ /
#  | | |  __/ (_| | (_| | | | | | |   <
#  |_|  \___|\__,_|\__,_|_|_|_| |_|_|\_\
#==============================================================================
# TOOL: READLINK
#==============================================================================
dm_tools__readlink() {
  case "$DM_TOOLS__RUNTIME__OS" in 

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      readlink "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__readlink__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__readlink - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__readlink__darwin() {
  dm_tools__target=''

  case "$#" in
    1)
      dm_tools__target="$1"
      ;;
    2)
      if [ "$1" = '-f' ]
      then
        dm_tools__target="$2"
      else
        exit 1
      fi
      ;;
    *)
      exit 1
      ;;
  esac

  python -c \
    'import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))' \
    "$dm_tools__target"
}

