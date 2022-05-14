#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'date - generated timestamp is numbers only'

if result="$(posix_adapter__date '+%s%N')"
then
  if echo "$result" | posix_adapter__grep --silent --extended '[[:digit:]]+'
  then
    posix_adapter__test__test_case_passed
  else
    status="$?"
    posix_adapter__test__test_case_failed "$status"
  fi
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'date - missing format should result an error'

if error_message="$(posix_adapter__date 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'date - multiple formats should result an error'

if error_message="$(posix_adapter__date 'format1' 'format2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'date - date does not handles options'

if error_message="$(posix_adapter__date --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'date - invalid option style'

if error_message="$(posix_adapter__date -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
