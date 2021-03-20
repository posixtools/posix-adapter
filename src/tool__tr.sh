#==============================================================================
#   _
#  | |_ _ __
#  | __| '__|
#  | |_| |
#   \__|_|
#==============================================================================
# TOOL: TR
#==============================================================================
dm_tools__tr() {
  # Default execution
  #----------------------------------------------------------------------------
  if tr "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__tr__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__tr - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__tr__special_execution_case_1() {
  # Collecting the optional parameters and its values.
  dm_tools__delete__present='0'
  dm_tools__delete__value=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --delete)
        dm_tools__delete__present='1'
        dm_tools__delete__value="$2"
        shift
        shift
        ;;
      *)
        echo "Unexpected tr parameter: '${dm_tools__param}'"
        exit 1
        ;;
    esac
  done

  # Assembling the decision string.
  # 0
  # `---- delete

  dm_tools__decision="${dm_tools__delete__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    1)
      tr -d "$dm_tools__delete__value"
      ;;
    *)
      >&2 echo "dm_tools__tr - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

