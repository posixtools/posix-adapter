#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] extended regexp mode'

expected='hello'

if result="$(posix_adapter__echo 'hello' | posix_adapter__grep --extended 'l+')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [path] extended regexp mode'

grep_file_path='./fixtures/grep/dummy_file_1'
expected='hello'

if result="$(posix_adapter__grep --extended 'l+' "$grep_file_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [both] file path input has priority'

grep_file_path='./fixtures/grep/dummy_file_1'
expected='hello'

if result="$( \
  posix_adapter__echo 'other' | posix_adapter__grep --extended 'l+' "$grep_file_path" \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi


#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] silent mode'

expected=''

if result="$(posix_adapter__echo 'hello' | posix_adapter__grep --silent '.')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [path] silent mode'

grep_file_path='./fixtures/grep/dummy_file_1'
expected=''

if result="$(posix_adapter__grep --silent '.' "$grep_file_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] inverted mode'

expected='hello'

if result="$(posix_adapter__echo 'hello' | posix_adapter__grep --invert-match 'imre')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [path] inverted mode'

grep_file_path='./fixtures/grep/dummy_file_1'
expected='hello'

if result="$(posix_adapter__grep --invert-match 'imre' "$grep_file_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] count mode'

expected='1'

if result="$(posix_adapter__echo 'hello' | posix_adapter__grep --count 'l')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] count mode'

grep_file_path='./fixtures/grep/dummy_file_1'
expected='1'

if result="$(posix_adapter__grep --count 'l' "$grep_file_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [stdin] only matching mode'

expected='ll'

if result="$( \
  posix_adapter__echo 'imre hello' | posix_adapter__grep --match-only 'll' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'grep - [path] only matching mode'

grep_file_path='./fixtures/grep/dummy_file_1'
expected='ll'

if result="$(posix_adapter__grep --match-only 'll' "$grep_file_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi


#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'grep - missing pattern should result an error'

if error_message="$(posix_adapter__grep 2>&1)"
then
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'grep - invalid option'

if error_message="$(posix_adapter__grep --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'grep - invalid option style'

if error_message="$(posix_adapter__grep -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
