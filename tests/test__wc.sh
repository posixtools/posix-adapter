#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'wc - [stdin] lines'

expected='3'

if result="$( \
  ( \
    dm_tools__echo 'a'; \
    dm_tools__echo 'b'; \
    dm_tools__echo 'c' \
  ) | dm_tools__wc --lines \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'wc - [path] lines'

path='fixtures/wc/dummy_file_1'
expected="3 ${path}"

if result="$(dm_tools__wc --lines "$path")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'wc - [stdin] chars'

expected='11'  # 10 numbers + newline

if result="$( dm_tools__echo '0123456789' | dm_tools__wc --chars)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'wc - [stdin] chars'

path='fixtures/wc/dummy_file_2'
expected="11 ${path}"

if result="$(dm_tools__wc --chars "$path")"
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
  'wc - multiple paths should result in an error'

if error_message="$(dm_tools__wc 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'wc - invalid option'

if error_message="$(dm_tools__wc --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'wc - invalid option style'

if error_message="$(dm_tools__wc -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
