#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'cat - file passed'

path='./fixtures/cat/dummy_file'
expected='dummy content'

if result="$(posix_adapter__cat "$path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'cat - standard input can be used'

expected='dummy content'

if result="$(echo "$expected" | posix_adapter__cat)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'cat - invalid parameter count'

if error_message="$(posix_adapter__cat 'one' 'two' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'cat - cat does not handles options'

if error_message="$(posix_adapter__cat --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'cat - invalid option style'

if error_message="$(posix_adapter__cat -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
