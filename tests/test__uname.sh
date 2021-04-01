#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'uname - parameter checking'

# if dm_tools__uname -s -r -m >/dev/null 2>&1
if dm_tools__uname --kernel-name --kernel-release --machine >/dev/null
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'uname - invalid parameter count 1'

if error_message="$(dm_tools__uname 'one' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'uname - invalid parameter count 2'

if error_message="$(dm_tools__uname 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'uname - invalid options'

if error_message="$(dm_tools__uname --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'uname - invalid option style'

if error_message="$(dm_tools__uname -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
