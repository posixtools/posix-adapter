#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'mkfifo - fifo can be created'

path='./fixtures/mkfifo/dummy_fifo'

if dm_tools__mkfifo "$path"
then
  if [ -p "$path" ]
  then
    dm_tools__rm "$path"
    dm_tools__test__test_case_passed
  else
    dm_tools__rm "$path"
    dm_tools__test__test_case_failed '1'
  fi
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'mkfifo - missing path should result in an error'

if error_message="$(dm_tools__mkfifo 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'mkfifo - multiple paths should result in an error'

if error_message="$(dm_tools__mkfifo 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mkfifo - mkfifo does not handles options'

if error_message="$(dm_tools__mkfifo --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mkfifo - invalid option style'

if error_message="$(dm_tools__mkfifo -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
