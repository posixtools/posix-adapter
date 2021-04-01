#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'xxd - encode'

expected='68656c6c6f0a'

if result="$( dm_tools__echo 'hello' | dm_tools__xxd --plain)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'xxd - decode'

expected='hello'

if result="$( dm_tools__echo '68656c6c6f0a' | dm_tools__xxd --plain --revert)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'xxd - invalid parameter count 1'

if error_message="$(dm_tools__xxd 'one' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'xxd - invalid parameter count 2'

if error_message="$(dm_tools__xxd 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'xxd - invalid options'

if error_message="$(dm_tools__xxd --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'xxd - invalid option style'

if error_message="$(dm_tools__xxd -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
