#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'cut - delimiter and field selection'

data='one/two/three/four'
expected='two/three/four'

if result="$( \
  posix_adapter__echo "$data" | posix_adapter__cut --delimiter '/' --fields '2-' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'cut - character range selection'

data='123456789'
expected='12345'

if result="$(posix_adapter__echo "$data" | posix_adapter__cut --characters '1-5')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'cut - delimiter and field selection file based'

path='./fixtures/cut/dummy_file_1'
expected='two/three/four'

if result="$( \
  posix_adapter__cut --delimiter '/' --fields '2-' "$path" \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'cut - character range selection'

path='./fixtures/cut/dummy_file_2'
expected='12345'

if result="$(posix_adapter__cut --characters '1-5' "$path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'cut - invalid parameter combination'

if error_message="$(posix_adapter__cut --characters '1' --delimiter 'x' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'cut - only one file path is acceptable'

if error_message="$(posix_adapter__cut --characters '1' 'file_1' 'file_2'  2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'cut - invalid option'

if error_message="$(posix_adapter__cut --invalid '1' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'cut - invalid option style'

if error_message="$(posix_adapter__cut -invalid '1' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
