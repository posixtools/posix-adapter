# These tests are working on the provided fixtures:
# tests/fixtures/find/
# ├── file_a_1
# ├── file_a_2
# └── file_b_1

#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'find - default path parameter'

if dm_tools__find >/dev/null
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'find - basic file search by name'

expected='2'

if result="$( \
  dm_tools__find './fixtures/find' --type 'f' --name 'file_a*' | \
  dm_tools__wc --lines \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'find - basic file search by name zero terminated'

expected='1'

# Same result as before but zero terminated -> only one line should be found.
if result="$( \
  dm_tools__find './fixtures/find' --type 'f' --name 'file_a*' --print0 | \
  dm_tools__wc --lines \
)"
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'find - basic direcroty search by name'

if dm_tools__find . --type 'd' --name '*' >/dev/null
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'find - basic directory search by name zero terminated'

expected='1'

if result="$( \
  dm_tools__find './fixtures' --type 'd' --name 'find' | \
  dm_tools__wc --lines \
)"
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'find - multiple paths should result an error'

if error_message="$(dm_tools__find 'one' 'two' 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'find - invalid option'

if error_message="$(dm_tools__find --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'find - invalid option style'

if error_message="$(dm_tools__find -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
