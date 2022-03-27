#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'echo - basic echo'

data='hello'
expected='hello'

if result="$(posix_adapter__echo "$data")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'echo - multiline output'

expected='2'

if result="$( ( posix_adapter__echo ''; posix_adapter__echo '') | posix_adapter__wc --lines)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'echo - omitting trailing newline'

expected='1'

if result="$( \
  ( posix_adapter__echo --no-newline 'a'; posix_adapter__echo 'b' ) | posix_adapter__wc --lines
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case \
  'echo - dashes wont interfere with the options - case 1'

data='-'
expected='-'

if result="$(posix_adapter__echo "$data")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case \
  'echo - dashes wont interfere with the options - case 2'

data='--'
expected='--'

if result="$(posix_adapter__echo "$data")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case \
  'echo - dashes wont interfere with the options - case 3'

data='---'
expected='---'

if result="$(posix_adapter__echo "$data")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'echo - missing string should result an error'

if error_message="$(posix_adapter__echo 2>&1)"
then
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'echo - multiple strings should result an error'

if error_message="$(posix_adapter__echo 'one' 'two' 2>&1)"
then
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'echo - invalid option'

if error_message="$(posix_adapter__echo --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'echo - invalid option style'

if error_message="$(posix_adapter__echo -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
