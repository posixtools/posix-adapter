#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'xargs - placeholder and additional parameters'

expected='hello'

if result="$(posix_adapter__echo 'hello' | posix_adapter__xargs --replace {} echo {} )"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'xargs - null terminated'

expected='hello'

if result="$(posix_adapter__echo 'hello' | posix_adapter__xargs --null)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'xargs - arg length 1 line will be broken up'

expected='2'

if result="$( \
  posix_adapter__echo 'hello imre' | \
  posix_adapter__xargs --max-args 1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'xargs - invalid options'

if error_message="$(posix_adapter__xargs --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'xargs - invalid option style'

if error_message="$(posix_adapter__xargs -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
