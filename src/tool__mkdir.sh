#==============================================================================
#             _       _ _
#   _ __ ___ | | ____| (_)_ __
#  | '_ ` _ \| |/ / _` | | '__|
#  | | | | | |   < (_| | | |
#  |_| |_| |_|_|\_\__,_|_|_|
#==============================================================================
# TOOL: MKDIR
#==============================================================================
dm_tools__mkdir() {
  # Default execution
  #----------------------------------------------------------------------------
  if mkdir "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__mkdir__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__mkdir - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__mkdir__special_execution_case_1() {
  # Collecting the optional parameters and its values.
  dm_tools__parents__present='0'

  dm_tools__positional=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --parents)
        # Only a flag, no value assigned to it.
        dm_tools__parents__present='1'
        shift
        ;;
      *)
        dm_tools__positional="${dm_tools__positional} '${dm_tools__param}'"
        shift
        ;;
    esac
  done

  # Assembling the decision string.
  # 0
  # `-- parents

  dm_tools__decision="${dm_tools__parents__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    1)
      # We want here word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      mkdir -p $dm_tools__positional
      ;;
    0)
      # We want here also word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      mkdir $dm_tools__positional
      ;;
    *)
      >&2 echo "dm_tools__mkdir - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

