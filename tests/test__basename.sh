#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'basename - basename can be retrieved'

data='/this/is/a/path'
expected='path'

if result="$(dm_tools__basename "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'basename - standard input can be used'

data='/this/is/a/path'
expected='path'

if result="$(dm_tools__echo "$data" | dm_tools__basename)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case \
  'basename - multiple paths should result in an error'

if error_message="$(dm_tools__basename 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'basename - basename does not handles options'

if error_message="$(dm_tools__basename --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'basename - invalid option style'

if error_message="$(dm_tools__basename -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
