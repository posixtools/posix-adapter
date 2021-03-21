#==============================================================================
#             _
#   ___ _   _| |_
#  / __| | | | __|
# | (__| |_| | |_
#  \___|\__,_|\__|
#==============================================================================
# TOOL: CUT
#==============================================================================

#==============================================================================
# Execution mapping function for the 'cut' command line tool.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --delimiter <delimiter> - cut compatible delimiter definition
#   --fields <fields> - cut compatible fields definition
#   --characters <characters> - cut compatible characters definition
# Arguments:
#   None
# STDIN:
#   Expected input source.
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Results.
# STDERR:
#   None
# Status:
#   0  - Call was successful.
#   .. - Invalid call or mapping run out of options.
#==============================================================================
dm_tools__cut() {
  case "$DM_TOOLS__RUNTIME__OS" in 

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      cut "$@"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__cut__darwin "$@"
      ;;

    *)
      >&2 echo 'dm_tools__cut - No compatible call style was found! Giving up..'
      exit 1

  esac
}

_dm_tools__cut__darwin() {
  # Collecting the optional parameters and its values.
  dm_tools__delimiter__present='0'
  dm_tools__delimiter__value=''
  dm_tools__fields__present='0'
  dm_tools__fields__value=''
  dm_tools__characters__present='0'
  dm_tools__characters__value=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --delimiter)
        dm_tools__delimiter__present='1'
        dm_tools__delimiter__value="$2"
        shift
        shift
        ;;
      --fields)
        dm_tools__fields__present='1'
        dm_tools__fields__value="$2"
        shift
        shift
        ;;
      --characters)
        dm_tools__characters__present='1'
        dm_tools__characters__value="$2"
        shift
        shift
        ;;
      *)
        >&2 echo "dm_tools__cut - Unexpected parameter: '${dm_tools__param}'"
        exit 1
        ;;
    esac
  done

  # Assembling the decision string.
  # 000
  # ||`-- characters
  # |`--- fields
  # `---- delimiter

  dm_tools__decision="${dm_tools__delimiter__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__fields__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__characters__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    110)
      cut -d "$dm_tools__delimiter__value" -f "$dm_tools__fields__value"
      ;;
    001)
      cut -c "$dm_tools__characters__value"
      ;;
    *)
      >&2 echo "dm_tools__cut - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}
