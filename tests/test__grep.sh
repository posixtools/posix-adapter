#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'grep - extended regexp mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep --extended 'l+')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'grep - silent mode'

expected=''

if result="$(dm_tools__echo "hello" | dm_tools__grep --silent '.')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'grep - inverted mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep --invert-match 'imre')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'grep - count mode'

expected='1'

if result="$(dm_tools__echo "hello" | dm_tools__grep --count 'l')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'grep - only matching mode'

expected='ll'

if result="$( \
  dm_tools__echo "imre hello" | dm_tools__grep --match-only 'll' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'grep - missing pattern should result an error'

if error_message="$(dm_tools__grep 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'grep - multiple patterns should result an error'

if error_message="$(dm_tools__grep 'one' 'two' 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'grep - invalid option'

if error_message="$(dm_tools__grep --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'grep - invalid option style'

if error_message="$(dm_tools__grep -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
