#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'date - generated timestamp is numbers only'

if result="$(dm_tools__date '+%s%N')"
then
  if dm_tools__echo "$result" | dm_tools__grep --silent --extended '[[:digit:]]+'
  then
    dm_tools__test__test_case_passed
  else
    status="$?"
    dm_tools__test__test_case_failed "$status"
  fi
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'date - missing format should result an error'

if error_message="$(dm_tools__date 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'date - multiple formats should result an error'

if error_message="$(dm_tools__date 'format1' 'format2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'date - date does not handles options'

if error_message="$(dm_tools__date --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'date - invalid option style'

if error_message="$(dm_tools__date -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
