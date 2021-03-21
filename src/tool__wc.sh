#==============================================================================
#
# __      _____
# \ \ /\ / / __|
#  \ V  V / (__
#   \_/\_/ \___|
#==============================================================================
# TOOL: WC
#==============================================================================
dm_tools__wc() {
  case "$DM_TOOLS__RUNTIME__OS" in 

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      wc "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__wc__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__wc - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__wc__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__lines__present='0'
  dm_tools__chars__present='0'

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --lines)
        dm_tools__lines__present='1'
        shift
        ;;
      --chars)
        dm_tools__chars__present='1'
        shift
        ;;
      *)
        >&2 echo "dm_tools__wc - Unexpected parameter: '${dm_tools__param}'"
        exit 1
        ;;
    esac
  done

  # Assembling the decision string.
  # 00
  # |`--- chars
  # `---- lines

  dm_tools__decision="${dm_tools__lines__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__chars__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    00)
      wc
      ;;
    01)
      # Some old BSD based wc implementations pads these results with empty
      # spaces, hence the additional xargs call.
      wc    -c | xargs
      ;;
    10)
      wc -l    | xargs
      ;;
    11)
      wc -l -c | xargs
      ;;
    *)
      >&2 echo "dm_tools__wc - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}
