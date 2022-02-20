#!/bin/sh
# These tests are working on the provided fixtures:
# tests/fixtures/readlink/
# ├── direct_symlink -> target_file
# ├── indirect_symlink -> direct_symlink
# └── target_file

#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'readlink - direct link can be resolved'

symlink_path='fixtures/readlink/direct_symlink'
expected='target_file'

if result="$(dm_tools__readlink "$symlink_path" | dm_tools__basename)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'readlink - indirect link will only resolve into the pointed symlink'

symlink_path='fixtures/readlink/indirect_symlink'
expected='direct_symlink'

if result="$(dm_tools__readlink "$symlink_path" | dm_tools__basename)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case \
  'readlink - indirect link with canonicalize mode can be resolved'

symlink_path='fixtures/readlink/indirect_symlink'
expected='target_file'

if result="$( \
  dm_tools__readlink --canonicalize "$symlink_path" | dm_tools__basename \
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
dm_tools__test__error_case 'readlink - only symlinks can be resolved'

symlink_path='fixtures/readlink/target_file'

if dm_tools__readlink "$symlink_path"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  dm_tools__test__test_case_passed
fi

#==============================================================================
dm_tools__test__error_case 'readlink - missing path should result in an error'

if error_message="$(dm_tools__readlink 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'readlink - multiple paths should result in an error'

if error_message="$(dm_tools__readlink 'link_1' 'link_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'readlink - invalid option'

if error_message="$(dm_tools__readlink --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'readlink - invalid option style'

if error_message="$(dm_tools__readlink -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
