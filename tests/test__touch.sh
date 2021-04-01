#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'touch - file can be created'

path='./fixtures/touch/dummy_file'

if dm_tools__touch "$path"
then
  dm_tools__test__test_case_passed
  dm_tools__rm "$path"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'touch - missing path argument'

if error_message="$(dm_tools__touch 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'touch - invalid parameter count'

if error_message="$(dm_tools__touch 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'touch - touch does not handles options'

if error_message="$(dm_tools__touch --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'touch - invalid option style'

if error_message="$(dm_tools__touch -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
