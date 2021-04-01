#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'cut - delimiter and field selection'

data='one/two/three/four'
expected='two/three/four'

if result="$( \
  dm_tools__echo "$data" | dm_tools__cut --delimiter '/' --fields '2-' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'cut - character range selection'

data='123456789'
expected='12345'

if result="$(dm_tools__echo "$data" | dm_tools__cut --characters '1-5')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'cut - delimiter and field selection file based'

path='./fixtures/cut/dummy_file_1'
expected='two/three/four'

if result="$( \
  dm_tools__cut --delimiter '/' --fields '2-' "$path" \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'cut - character range selection'

path='./fixtures/cut/dummy_file_2'
expected='12345'

if result="$(dm_tools__cut --characters '1-5' "$path")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'cut - invalid parameter combination'

if error_message="$(dm_tools__cut --characters '1' --delimiter 'x' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'cut - only one file path is acceptable'

if error_message="$(dm_tools__cut --characters '1' 'file_1' 'file_2'  2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'cut - invalid option'

if error_message="$(dm_tools__cut --invalid '1' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'cut - invalid option style'

if error_message="$(dm_tools__cut -invalid '1' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
