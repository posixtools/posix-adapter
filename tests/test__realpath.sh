# These tests are working on the provided fixtures:
# tests/fixtures/realpath/
# ├── direct_symlink -> target_file
# └── target_file

#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'realpath - default mode'

target_path='fixtures/realpath/target_file'
expected='target_file'

if result="$(dm_tools__realpath "$target_path" | dm_tools__basename)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'realpath - no-symlink mode'

target_path='fixtures/realpath/direct_link'
expected='direct_link'

if result="$(dm_tools__realpath --no-symlink "$target_path" | dm_tools__basename)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'realpath - missing path should result in an error'

if error_message="$(dm_tools__realpath 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'realpath - multiple paths should result in an error'

if error_message="$(dm_tools__realpath 'link_1' 'link_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'realpath - invalid option'

if error_message="$(dm_tools__realpath --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'realpath - invalid option style'

if error_message="$(dm_tools__realpath -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
