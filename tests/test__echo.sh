#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'echo - basic echo'

data='hello'
expected='hello'

if result="$(dm_tools__echo "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'echo - multiline output'

expected='2'

if result="$( ( dm_tools__echo ''; dm_tools__echo '') | dm_tools__wc --lines)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'echo - omitting trailing newline'

expected='1'

if result="$( \
  ( dm_tools__echo --no-newline 'a'; dm_tools__echo 'b' ) | dm_tools__wc --lines
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'echo - dashes wont interfere with the options - case 1'

data='-'
expected='-'

if result="$(dm_tools__echo "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'echo - dashes wont interfere with the options - case 2'

data='--'
expected='--'

if result="$(dm_tools__echo "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'echo - dashes wont interfere with the options - case 3'

data='---'
expected='---'

if result="$(dm_tools__echo "$data")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'echo - missing string should result an error'

if error_message="$(dm_tools__echo 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'echo - multiple strings should result an error'

if error_message="$(dm_tools__echo 'one' 'two' 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'echo - invalid option'

if error_message="$(dm_tools__echo --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'echo - invalid option style'

if error_message="$(dm_tools__echo -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
