# These tests are working on the provided fixtures:
# tests/fixtures/ls/
# ├── dummy_dir
# │   └── .gitkeep
# ├── dummy_file
# └── .hidden_file

#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'ls - directory can be listed in the default mode'

test_path='fixtures/ls'
# ..           0
# .            0
# dummy_dir    1
# dummy_file   1
# .hidden_file 0
expected='2'

if result="$(dm_tools__ls "$test_path" | dm_tools__wc --words)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'ls - directory can be listed in the all mode'

test_path='fixtures/ls'
# ..           1
# .            1
# dummy_dir    1
# dummy_file   1
# .hidden_file 1
expected='5'

if result="$(dm_tools__ls --all "$test_path" | dm_tools__wc --words)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'ls - directory can be listed in the almost all mode'

test_path='fixtures/ls'
# ..           0
# .            0
# dummy_dir    1
# dummy_file   1
# .hidden_file 1
expected='3'

if result="$(dm_tools__ls --almost-all "$test_path" | dm_tools__wc --words)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'ls - both all and almost all cannot be specified'

test_path='fixtures/ls'

if error_message="$(dm_tools__ls --all --almost-all "$test_path" 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'ls - missing path should result in an error'

if error_message="$(dm_tools__ls 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'ls - multiple paths should result in an error'

if error_message="$(dm_tools__ls 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'ls - invalid option'

if error_message="$(dm_tools__ls --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'ls - invalid option style'

if error_message="$(dm_tools__ls -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
