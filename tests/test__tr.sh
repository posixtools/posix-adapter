#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'tr - delete newline'

expected='abc'

if result="$( \
  ( \
    posix_adapter__echo 'a'; \
    posix_adapter__echo 'b'; \
    posix_adapter__echo 'c' \
  ) | posix_adapter__tr --delete '\n' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'tr - replace newline'

expected='a b c '

if result="$( \
  ( \
    posix_adapter__echo 'a'; \
    posix_adapter__echo 'b'; \
    posix_adapter__echo 'c' \
  ) | posix_adapter__tr --replace '\n' ' ' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'tr - squeeze repeats - character'

expected='abc'

if result="$( \
  posix_adapter__echo 'abbbc' | \
  posix_adapter__tr --squeeze-repeats 'b' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'tr - squeeze repeats - character class'

expected='a b'

if result="$( \
  posix_adapter__echo 'a       b' | \
  posix_adapter__tr --squeeze-repeats '[[:space:]]' \
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
posix_adapter__test__error_case 'tr - invalid parameter count 1'

if error_message="$(posix_adapter__tr 'one' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'tr - invalid parameter count 2'

if error_message="$(posix_adapter__tr 'one' 'two' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'tr - invalid options - only delete or replace'

if error_message="$(posix_adapter__tr --delete 'a' --replace 'b' 'c' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_incompatible_call "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'tr - invalid options'

if error_message="$(posix_adapter__tr --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'tr - invalid option style'

if error_message="$(posix_adapter__tr -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
