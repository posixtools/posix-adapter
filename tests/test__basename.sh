#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'basename - basename can be retrieved'

data='/this/is/a/path'
expected='path'

if result="$(posix_adapter__basename "$data")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'basename - standard input can be used'

data='/this/is/a/path'
expected='path'

if result="$(echo "$data" | posix_adapter__basename)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case \
  'basename - multiple paths should result in an error'

if error_message="$(posix_adapter__basename 'one' 'two' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'basename - basename does not handles options'

if error_message="$(posix_adapter__basename --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'basename - invalid option style'

if error_message="$(posix_adapter__basename -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
