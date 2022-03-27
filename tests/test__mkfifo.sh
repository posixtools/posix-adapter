#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'mkfifo - fifo can be created'

path='./fixtures/mkfifo/dummy_fifo'

if posix_adapter__mkfifo "$path"
then
  if [ -p "$path" ]
  then
    posix_adapter__rm "$path"
    posix_adapter__test__test_case_passed
  else
    posix_adapter__rm "$path"
    posix_adapter__test__test_case_failed '1'
  fi
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'mkfifo - missing path should result in an error'

if error_message="$(posix_adapter__mkfifo 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'mkfifo - multiple paths should result in an error'

if error_message="$(posix_adapter__mkfifo 'one' 'two' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mkfifo - mkfifo does not handles options'

if error_message="$(posix_adapter__mkfifo --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mkfifo - invalid option style'

if error_message="$(posix_adapter__mkfifo -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
