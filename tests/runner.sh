#!/bin/sh

#==============================================================================
# This testing file is intended to test the dependent program and shell
# built-ins to have the required behavior on each supported platforms. We are
# using full manual test suite with no automations. posix_test cannot be used here
# because it is relying on this library.
#==============================================================================

#==============================================================================
# SANE ENVIRONMENT
#==============================================================================

set -e  # exit on error
set -u  # prevent unset variable expansion

#==============================================================================
# PATH CHANGE
#==============================================================================

# This is the only part where the code has to be prepared for the missing tool
# capabilities. It is known that on MacOS readlink does not support the -f flag
# by default. https://stackoverflow.com/a/4031502/1565331
if target_path="$(readlink -f "$0" 2>/dev/null)"
then
  cd "$(dirname "$target_path")"
else
  # If the path cannot be determined with readlink, we have to check if this
  # script is executed through a symlink or not.
  if [ -L "$0" ]
  then
    # If the current script is executed through a symlink, we are aout of luck,
    # because without readlink, there is no universal solution for this problem
    # that uses the default shell toolset.
    echo "Symlinked script won't work on this machine.."
    echo "Make sure you install a readlink version that supports the -f flag."
  else
    # If the current script is not executed through a symlink, we can determine
    # the path with dirname.
    cd "$(dirname "$0")"
  fi
fi

#==============================================================================
# POSIX ADAPTER INTEGRATION
#==============================================================================

if [ -z ${POSIX_ADAPTER__READY+x} ]
then
  POSIX_ADAPTER__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX='..'
  # shellcheck source=../posix_adapter.sh
  . "${POSIX_ADAPTER__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX}/posix_adapter.sh"
fi

#==============================================================================
# COMMON HELPERS
#==============================================================================

. './common.sh'

#==============================================================================
# TEST SUITE EXECUTION
#==============================================================================

posix_adapter__test__log_task 'Running test suite..'

printf '%s' "${DIM}"
printf '%s' '================================================================='
printf '%s\n' '==================='
printf '%s\n' ' TEST SYSTEM EVALUATION'
printf '%s' '================================================================='
printf '%s' '==================='
printf '%s\n' "${RESET}"

. './test__0__common.sh'

printf '%s' "${DIM}"
printf '%s' '================================================================='
printf '%s\n' '==================='
printf '%s\n' ' POSIX ADAPTER TEST SUITE'
printf '%s' '================================================================='
printf '%s' '==================='
printf '%s\n' "${RESET}"

printf '%s' "${DIM}"
printf '%s' \
  'After this point, red error messages mean an actual error in posix_adapter!'
printf '%s\n' "${RESET}"

posix_adapter__test__line
. './test__basename.sh'
posix_adapter__test__line
. './test__cat.sh'
posix_adapter__test__line
. './test__cut.sh'
posix_adapter__test__line
. './test__dirname.sh'
posix_adapter__test__line
. './test__date.sh'
posix_adapter__test__line
. './test__find.sh'
posix_adapter__test__line
. './test__fold.sh'
posix_adapter__test__line
. './test__grep.sh'
posix_adapter__test__line
. './test__ln.sh'
posix_adapter__test__line
. './test__ls.sh'
posix_adapter__test__line
. './test__mkdir.sh'
posix_adapter__test__line
. './test__mkfifo.sh'
posix_adapter__test__line
. './test__mktemp.sh'
posix_adapter__test__line
. './test__readlink.sh'
posix_adapter__test__line
. './test__realpath.sh'
posix_adapter__test__line
. './test__rm.sh'
posix_adapter__test__line
. './test__sed.sh'
posix_adapter__test__line
. './test__sort.sh'
posix_adapter__test__line
. './test__touch.sh'
posix_adapter__test__line
. './test__tput.sh'
posix_adapter__test__line
. './test__tr.sh'
posix_adapter__test__line
. './test__uname.sh'
posix_adapter__test__line
. './test__wc.sh'
posix_adapter__test__line
. './test__xargs.sh'
posix_adapter__test__line
. './test__xxd.sh'

echo '-------------------------------------------------------------------------------'

posix_adapter__test__log_success 'Test suite finished'

#==============================================================================
# SHELLCHECK VALIDATION
#==============================================================================

if command -v shellcheck >/dev/null
then
  current_path="$(pwd)"
  cd ../src
  # Specifying shell type here to be able to omit the shebangs from the
  # modules.
  # More info: https://github.com/koalaman/shellcheck/wiki/SC2148
  shellcheck --shell=sh -x ./*
  cd "$current_path"
else
  echo "WARNING: shellcheck won't be executed as it cannot be found."
fi
