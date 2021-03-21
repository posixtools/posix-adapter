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

dm_tools__log_task 'Running test suite..'

dm_tools__echo -n '-------------------------------------------------------'
dm_tools__echo '------------------------'

. './test__basename.sh'
. './test__cat.sh'
. './test__cut.sh'
. './test__date.sh'
. './test__dirname.sh'
. './test__echo.sh'
. './test__find.sh'
. './test__grep.sh'
. './test__mkdir.sh'
. './test__mkfifo.sh'
. './test__mktemp.sh'
. './test__printf.sh'
. './test__readlink.sh'
. './test__realpath.sh'
. './test__rm.sh'
. './test__sed.sh'
. './test__sort.sh'
. './test__touch.sh'
. './test__tput.sh'
. './test__tr.sh'
. './test__uname.sh'
. './test__wc.sh'
. './test__xargs.sh'
. './test__xxd.sh'

dm_tools__echo -n '-------------------------------------------------------'
dm_tools__echo '------------------------'

dm_tools__log_success 'Test suite finished'
