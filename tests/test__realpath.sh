#!/bin/sh
# These tests are working on the provided fixtures:
# tests/fixtures/realpath/
# ├── dir_1
# ├── dir_2
# │   └── direct_symlink -> ../target_file
# ├── direct_symlink -> target_file
# └── target_file

#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'realpath - 00 - no symlink'

# Target file absolute path should be returned.
target_path='fixtures/realpath/target_file'
expected="$(pwd)/fixtures/realpath/target_file"

if result="$(posix_adapter__realpath "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 00 - symlink'

# Target file should be accessible through the direct symlink.
target_path='fixtures/realpath/direct_symlink'
expected="$(pwd)/fixtures/realpath/target_file"

if result="$(posix_adapter__realpath "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 01 - no symlink'

target_path='fixtures/realpath/target_file'
relative_to='fixtures/realpath/dir_1'
expected="../target_file"

if result="$(posix_adapter__realpath --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 01 - symlink - same path'

# Relative calculations should be possible through a symlink.
target_path='fixtures/realpath/direct_symlink'
relative_to='fixtures/realpath/dir_1'
expected="../target_file"

if result="$(posix_adapter__realpath --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 01 - symlink - different path'

# Relative calculations should be possible through a symlink.
target_path='fixtures/realpath/dir_2/direct_symlink'
relative_to='fixtures/realpath/dir_1'
expected="../target_file"

if result="$(posix_adapter__realpath --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 10 - no symlink'

# Target file absolute path should be returned.
target_path='fixtures/realpath/target_file'
expected="$(pwd)/fixtures/realpath/target_file"

if result="$(posix_adapter__realpath --no-symlinks "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 10 - symlink'

# No symlinks should be followed, the symlink's absolute path should be returned.
target_path='fixtures/realpath/direct_symlink'
expected="$(pwd)/fixtures/realpath/direct_symlink"

if result="$(posix_adapter__realpath --no-symlinks "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 11 - no symlink'

target_path='fixtures/realpath/target_file'
relative_to='fixtures/realpath/dir_1'
expected="../target_file"

if result="$(posix_adapter__realpath --no-symlinks --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 11 - symlink - same path'

# Relative calculations should be possible through a symlink.
target_path='fixtures/realpath/direct_symlink'
relative_to='fixtures/realpath/dir_1'
expected="../direct_symlink"

if result="$(posix_adapter__realpath --no-symlinks --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'realpath - 11 - symlink - different path'

# Relative calculations should be possible through a symlink.
target_path='fixtures/realpath/dir_2/direct_symlink'
relative_to='fixtures/realpath/dir_1'
expected="../dir_2/direct_symlink"

if result="$(posix_adapter__realpath --no-symlinks --relative-to "$relative_to" "$target_path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'realpath - missing path should result in an error'

if error_message="$(posix_adapter__realpath 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'realpath - multiple paths should result in an error'

if error_message="$(posix_adapter__realpath 'link_1' 'link_2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'realpath - invalid option'

if error_message="$(posix_adapter__realpath --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'realpath - invalid option style'

if error_message="$(posix_adapter__realpath -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
