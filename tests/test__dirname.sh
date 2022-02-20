#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'dirname - dir name can be retrieved'

data='/this/is/a/path'
expected='/this/is/a'

if result="$(dm_tools__dirname "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'dirname - standard input can be used'

data='/this/is/a/path'
expected='/this/is/a'

if result="$(dm_tools__echo "$data" | dm_tools__dirname)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'dirname - multiple paths should result an error'

if error_message="$(dm_tools__dirname 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'dirname - dirname does not handles options'

if error_message="$(dm_tools__dirname --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'dirname - invalid option style'

if error_message="$(dm_tools__dirname -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
