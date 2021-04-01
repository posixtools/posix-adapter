#!/bin/sh

#==============================================================================
# This testing file is intended to test the dependent program and shell
# built-ins to have the required behavior on each supported platforms. We are
# using full manual test suite with no automations. dm_test cannot be used here
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
# DM TOOLS INTEGRATION
#==============================================================================

if [ -z ${DM_TOOLS__READY+x} ]
then
  DM_TOOLS__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX='..'
  # shellcheck source=../dm.tools.sh
  . "${DM_TOOLS__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX}/dm.tools.sh"
fi

#==============================================================================
# COMMON HELPERS
#==============================================================================

. './common.sh'

#==============================================================================
# TEST SUITE EXECUTION
#==============================================================================

dm_tools__test__log_task 'Running test suite..'

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
printf '%s\n' ' DM TOOLS TEST SUITE'
printf '%s' '================================================================='
printf '%s' '==================='
printf '%s\n' "${RESET}"

printf '%s' "${DIM}"
printf '%s' \
  'After this point, red error messages mean an actual error in dm_tools!'
printf '%s\n' "${RESET}"

dm_tools__test__line
. './test__basename.sh'
dm_tools__test__line
. './test__cat.sh'
dm_tools__test__line
. './test__cut.sh'
dm_tools__test__line
. './test__date.sh'
dm_tools__test__line
. './test__dirname.sh'
dm_tools__test__line
. './test__echo.sh'
dm_tools__test__line
. './test__find.sh'
dm_tools__test__line
. './test__grep.sh'
dm_tools__test__line
. './test__mkdir.sh'
dm_tools__test__line
. './test__mkfifo.sh'
dm_tools__test__line
. './test__mktemp.sh'
dm_tools__test__line
. './test__printf.sh'
dm_tools__test__line
. './test__readlink.sh'
dm_tools__test__line
. './test__realpath.sh'
dm_tools__test__line
. './test__rm.sh'
dm_tools__test__line
. './test__sed.sh'
dm_tools__test__line
. './test__sort.sh'
dm_tools__test__line
. './test__touch.sh'
dm_tools__test__line
. './test__tr.sh'
dm_tools__test__line
. './test__uname.sh'
dm_tools__test__line
. './test__wc.sh'
dm_tools__test__line
. './test__xargs.sh'
dm_tools__test__line
. './test__xxd.sh'

dm_tools__echo --no-newline '-------------------------------------------------'
dm_tools__echo '------------------------------'

dm_tools__test__log_success 'Test suite finished'
