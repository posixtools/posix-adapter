#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'wc - [stdin] lines'

expected='3'

if result="$( \
  ( \
    posix_adapter__echo 'a'; \
    posix_adapter__echo 'b'; \
    posix_adapter__echo 'c' \
  ) | posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'wc - [path] lines'

path='fixtures/wc/dummy_file_lines'
expected="3 ${path}"

if result="$(posix_adapter__wc --lines "$path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'wc - [stdin] chars'

expected='11'  # 10 numbers + newline

if result="$( posix_adapter__echo '0123456789' | posix_adapter__wc --chars)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'wc - [path] chars'

path='fixtures/wc/dummy_file_chars'
expected="11 ${path}"

if result="$(posix_adapter__wc --chars "$path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'wc - [stdin] words'

expected='3'  # 10 numbers + newline

if result="$( posix_adapter__echo 'one two three' | posix_adapter__wc --words)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'wc - [path] words'

path='fixtures/wc/dummy_file_words'
expected="3 ${path}"

if result="$(posix_adapter__wc --words "$path")"
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
  'wc - cannot have multiple modes at once - case 1'

if error_message="$(posix_adapter__wc --chars --lines 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'wc - cannot have multiple modes at once - case 2'

if error_message="$(posix_adapter__wc --chars --words 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'wc - cannot have multiple modes at once - case 3'

if error_message="$(posix_adapter__wc --lines --words 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'wc - cannot have multiple modes at once - case 4'

if error_message="$(posix_adapter__wc --chars --lines --words 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'wc - multiple paths should result in an error'

if error_message="$(posix_adapter__wc 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'wc - invalid option'

if error_message="$(posix_adapter__wc --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'wc - invalid option style'

if error_message="$(posix_adapter__wc -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
