#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'tput - tput call can be executed'

# Have to check if tput is available because some test runners don't have it.
if posix_adapter__tput --is-available
then
  if posix_adapter__tput longname >/dev/null 2>&1
  then
    posix_adapter__test__test_case_passed
  else
    status="$?"
    posix_adapter__test__test_case_failed "$status"
  fi
fi
