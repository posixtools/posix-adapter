#==============================================================================
#
# __  ____ _ _ __ __ _ ___
# \ \/ / _` | '__/ _` / __|
#  >  < (_| | | | (_| \__ \
# /_/\_\__,_|_|  \__, |___/
#================|___/=========================================================
# TOOL: XARGS
#==============================================================================
dm_tools__xargs() {
  # Default execution
  #----------------------------------------------------------------------------
  if xargs "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__xargs__special_execution_case_1 "$@"
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__wc - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__xargs__special_execution_case_1() {
  # Collecting the optional parameters and its values.
  dm_tools__null__present='0'
  dm_tools__pattern__present='0'
  dm_tools__pattern__value=''
  dm_tools__max_args__present='0'
  dm_tools__max_args__value=''

  while [ "$#" -gt '0' ]
  do
    dm_tools__param="$1"
    case "$dm_tools__param" in
      --null)
        dm_tools__null__present='1'
        shift
        ;;
      -I)
        dm_tools__pattern__present='1'
        dm_tools__pattern__value="$2"
        shift
        shift
        ;;
      --max-args)
        dm_tools__max_args__present='1'
        dm_tools__max_args__value="$2"
        shift
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
  # 000
  # ||`- max-args
  # |`-- pattern
  # `--- null

  dm_tools__decision="${dm_tools__null__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__pattern__present}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__max_args__present}"

  # Execution based on the decision string.
  case "$dm_tools__decision" in
    000)
      xargs "$@"
      ;;
    001)
      xargs -n "$dm_tools__max_args__value" "$@"
      ;;
    010)
      xargs -I "$dm_tools__pattern__value" "$@"
      ;;
    011)
      xargs -I "$dm_tools__pattern__value" -n "$dm_tools__max_args__value" "$@"
      ;;
    100)
      xargs -0 "$@"
      ;;
    101)
      xargs -0 -n "$dm_tools__max_args__value" "$@"
      ;;
    110)
      xargs -0 -I "$dm_tools__pattern__value" "$@"
      ;;
    111)
      xargs -0 -I "$dm_tools__pattern__value" -n "$dm_tools__max_args__value" "$@"
      ;;
    *)
      >&2 echo "dm_tools__xargs - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

