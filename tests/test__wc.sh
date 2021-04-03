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

path='fixtures/wc/dummy_file_lines'
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
dm_tools__test__valid_case 'wc - [path] chars'

path='fixtures/wc/dummy_file_chars'
expected="11 ${path}"

if result="$(dm_tools__wc --chars "$path")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'wc - [stdin] words'

expected='3'  # 10 numbers + newline

if result="$( dm_tools__echo 'one two three' | dm_tools__wc --words)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'wc - [path] words'

path='fixtures/wc/dummy_file_words'
expected="3 ${path}"

if result="$(dm_tools__wc --words "$path")"
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
  'wc - cannot have multiple modes at once - case 1'

if error_message="$(dm_tools__wc --chars --lines 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'wc - cannot have multiple modes at once - case 2'

if error_message="$(dm_tools__wc --chars --words 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'wc - cannot have multiple modes at once - case 3'

if error_message="$(dm_tools__wc --lines --words 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'wc - cannot have multiple modes at once - case 4'

if error_message="$(dm_tools__wc --chars --lines --words 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

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
