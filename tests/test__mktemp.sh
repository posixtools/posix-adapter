#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'mktemp - temp file can be created'

path='./fixtures/mktemp'
template_base='dummy_temp'
template="${template_base}.XXXXXX"

# Created temp file and the .gitkeep file.
expected='2'

if posix_adapter__mktemp --tmpdir "$path" "$template" >/dev/null
then
  result="$(posix_adapter__find "$path" --type 'f' | posix_adapter__wc --lines)"
  posix_adapter__rm ${path}/${template_base}.*
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__rm --force ${path}/${template_base}.*
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'mktemp - temp directory can be created'

path='./fixtures/mktemp'
template_base='dummy_temp'
template="${template_base}.XXXXXX"

# Containing direcotry + temporary directory. Find's stuff..
expected='2'

if posix_adapter__mktemp --directory --tmpdir "$path" "$template" >/dev/null
then
  result="$(posix_adapter__find "$path" --type 'd' | posix_adapter__wc --lines)"
  posix_adapter__rm --recursive ${path}/${template_base}.*
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__rm --recursive --force ${path}/${template_base}.*
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'mktemp - missing pattern should result in an error'

if error_message="$(posix_adapter__mktemp 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'mktemp - multiple templates should result in an error'

if error_message="$(posix_adapter__mktemp 'one' 'two' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mktemp - invalid option'

if error_message="$(posix_adapter__mktemp --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mktemp - invalid option style'

if error_message="$(posix_adapter__mktemp -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
