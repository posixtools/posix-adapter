#!/bin/sh
#==============================================================================
#       _            _              _           _
#      | |          | |            | |         | |
#    __| |_ __ ___  | |_ ___   ___ | |___   ___| |__
#   / _` | '_ ` _ \ | __/ _ \ / _ \| / __| / __| '_ \
#  | (_| | | | | | || || (_) | (_) | \__ \_\__ \ | | |
#   \__,_|_| |_| |_(_)__\___/ \___/|_|___(_)___/_| |_|
#
#==============================================================================

#==============================================================================
# SANE ENVIRONMENT
#==============================================================================

set -e  # exit on error
set -u  # prevent unset variable expansion

#==============================================================================
# TOOL MAPPINGS
#==============================================================================

#==============================================================================
#   _
#  | |__   __ _ ___  ___ _ __   __ _ _ __ ___   ___
#  | '_ \ / _` / __|/ _ \ '_ \ / _` | '_ ` _ \ / _ \
#  | |_) | (_| \__ \  __/ | | | (_| | | | | | |  __/
#  |_.__/ \__,_|___/\___|_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: BASENAME
#==============================================================================
dm_tools__basename() {
  basename "$@"
}

#==============================================================================
#            _
#   ___ __ _| |_
#  / __/ _` | __|
# | (_| (_| | |_
#  \___\__,_|\__|
#==============================================================================
# TOOL: CAT
#==============================================================================
dm_tools__cat() {
  cat "$@"
}

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
  # Default execution
  #----------------------------------------------------------------------------
  if cut "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__cut__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__cut - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__cut__special_execution_case_1() {
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

#==============================================================================
#      _       _
#   __| | __ _| |_ ___
#  / _` |/ _` | __/ _ \
# | (_| | (_| | ||  __/
#  \__,_|\__,_|\__\___|
#==============================================================================
# TOOL: DATE
#==============================================================================
dm_tools__date() {
  date "$@"
}

#==============================================================================
#      _ _
#   __| (_)_ __ _ __   __ _ _ __ ___   ___
#  / _` | | '__| '_ \ / _` | '_ ` _ \ / _ \
# | (_| | | |  | | | | (_| | | | | | |  __/
#  \__,_|_|_|  |_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: DIRNAME
#==============================================================================
dm_tools__dirname() {
  dirname "$@"
}

#==============================================================================
#            _
#   ___  ___| |__   ___
#  / _ \/ __| '_ \ / _ \
# |  __/ (__| | | | (_) |
#  \___|\___|_| |_|\___/
#==============================================================================
# TOOL: ECHO
#==============================================================================
dm_tools__echo() {
  echo "$@"
}

#==============================================================================
#    __ _           _
#   / _(_)_ __   __| |
#  | |_| | '_ \ / _` |
#  |  _| | | | | (_| |
#  |_| |_|_| |_|\__,_|
#==============================================================================
# TOOL: FIND
#==============================================================================
dm_tools__find() {
  find "$@"
}

#==============================================================================
#   __ _ _ __ ___ _ __
#  / _` | '__/ _ \ '_ \
# | (_| | | |  __/ |_) |
#  \__, |_|  \___| .__/
#==|___/=========|_|===========================================================
# TOOL: GREP
#==============================================================================
dm_tools__grep() {
  grep "$@"
}

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

#==============================================================================
#             _     __ _  __
#   _ __ ___ | | __/ _(_)/ _| ___
#  | '_ ` _ \| |/ / |_| | |_ / _ \
#  | | | | | |   <|  _| |  _| (_) |
#  |_| |_| |_|_|\_\_| |_|_|  \___/
#==============================================================================
# TOOL: MKFIFO
#==============================================================================
dm_tools__mkfifo() {
  mkfifo "$@"
}

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
  mktemp "$@"
}

#==============================================================================
#              _       _    __
#   _ __  _ __(_)_ __ | |_ / _|
#  | '_ \| '__| | '_ \| __| |_
#  | |_) | |  | | | | | |_|  _|
#  | .__/|_|  |_|_| |_|\__|_|
#==|_|=========================================================================
# TOOL: PRINTF
#==============================================================================
dm_tools__printf() {
  printf "$@"
}

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
  # Default execution
  #----------------------------------------------------------------------------
  if readlink "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__readlink__special_execution_case_1 "$@"
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__readlink - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__readlink__special_execution_case_1() {
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
  # Default execution
  #----------------------------------------------------------------------------
  if realpath "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__realpath__special_execution_case_1 "$@"
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__realpath - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__realpath__special_execution_case_1() {
  # Collecting the optional parameters and its values.
  dm_tools__no_symlink__present='0'

  dm_tools__positional=''

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
        # We are expecting here a single positional argument.
        dm_tools__positional="$dm_tools__param"
        shift
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
        "$dm_tools__positional"
      ;;
    0)
      # Regular call.
      python -c \
        'import os,sys; print(os.path.abspath(os.path.expanduser(sys.argv[1])))' \
        "$dm_tools__positional"
      ;;
    *)
      >&2 echo "dm_tools__realpath - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

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
  # Default execution
  #----------------------------------------------------------------------------
  if rm "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__rm__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__rm - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__rm__special_execution_case_1() {
  # Collecting the optional parameters and its values.
  dm_tools__recursive__present='0'
  dm_tools__force__present='0'

  dm_tools__positional=''

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
        dm_tools__positional="${dm_tools__positional} '${dm_tools__param}'"
        shift
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
      # We want here word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      rm $dm_tools__positional
      ;;
    01)
      # We want here word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      rm -f $dm_tools__positional
      ;;
    10)
      # We want here word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      rm -r $dm_tools__positional
      ;;
    11)
      # We want here word splitting for the positional parameters.
      # shellcheck disable=SC2086,SC2090
      rm -r -f $dm_tools__positional
      ;;
    *)
      >&2 echo "dm_tools__rm - Unexpected combination: '${dm_tools__decision}'"
      exit 1
      ;;
  esac
}

#==============================================================================
#                _
#   ___  ___  __| |
#  / __|/ _ \/ _` |
#  \__ \  __/ (_| |
#  |___/\___|\__,_|
#==============================================================================
# TOOL: SED
#==============================================================================
dm_tools__sed() {
  sed "$@"
}

#==============================================================================
#                  _
#   ___  ___  _ __| |_
#  / __|/ _ \| '__| __|
#  \__ \ (_) | |  | |_
#  |___/\___/|_|   \__|
#==============================================================================
# TOOL: SORT
#==============================================================================
dm_tools__sort() {
  sort "$@"
}

#==============================================================================
#   _                   _
#  | |_ ___  _   _  ___| |__
#  | __/ _ \| | | |/ __| '_ \
#  | || (_) | |_| | (__| | | |
#   \__\___/ \__,_|\___|_| |_|
#==============================================================================
# TOOL: TOUCH
#==============================================================================
dm_tools__touch() {
  touch "$@"
}

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

#==============================================================================
#   _               _
#  | |_ _ __  _   _| |_
#  | __| '_ \| | | | __|
#  | |_| |_) | |_| | |_
#   \__| .__/ \__,_|\__|
#======|_|=====================================================================
# TOOL: TPUT
#==============================================================================
dm_tools__tput() {
  tput "$@"
}

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
  # Default execution
  #----------------------------------------------------------------------------
  if uname "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__uname__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__uname - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__uname__special_execution_case_1() {
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
  # Default execution
  #----------------------------------------------------------------------------
  if wc "$@" 2>/dev/null
  then
    return 0
  fi

  # Special execution case 1
  #----------------------------------------------------------------------------
  if _dm_tools__wc__special_execution_case_1 "$@" 2>/dev/null
  then
    return 0
  fi

  # Giving up..
  #----------------------------------------------------------------------------
  >&2 echo 'dm_tools__wc - No compatible call style was found! Giving up..'
  exit 1
}

_dm_tools__wc__special_execution_case_1() {
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

#==============================================================================
#                _
# __  ____  ____| |
# \ \/ /\ \/ / _` |
#  >  <  >  < (_| |
# /_/\_\/_/\_\__,_|
#==============================================================================
# TOOL: XXD
#==============================================================================
dm_tools__xxd() {
  xxd "$@"
}
