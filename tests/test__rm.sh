#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'rm - file can be deleted'

base_path='fixtures/rm'
dummy_file="${base_path}/dummy_file"

posix_adapter__touch "$dummy_file"

if ! posix_adapter__rm "$dummy_file"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  posix_adapter__find "$base_path" --type 'f' --name 'dummy_file' | \
  posix_adapter__wc --lines \
)"
posix_adapter__test__assert_equal "$expected" "$result"

#==============================================================================
posix_adapter__test__valid_case 'rm - directory can be deleted'

base_path='fixtures/rm'
dummy_directory="${base_path}/dummy_directory"

posix_adapter__mkdir --parents "$dummy_directory"

if ! posix_adapter__rm --recursive "$dummy_directory"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  posix_adapter__find "$base_path" --type 'd' --name 'dummy_directory' | \
  posix_adapter__wc --lines \
)"
posix_adapter__test__assert_equal "$expected" "$result"

#==============================================================================
posix_adapter__test__valid_case 'rm - non-existent file can be ignored with force'

base_path='fixtures/rm'
dummy_file="${base_path}/non-existent-file"

if posix_adapter__rm --force "$dummy_file"
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'rm - file can be deleted - verbose'

base_path='fixtures/rm'
dummy_file="${base_path}/dummy_file"

posix_adapter__touch "$dummy_file"

if output="$(posix_adapter__rm --verbose "$dummy_file")"
then
  if [ -z "$output" ]
  then
    posix_adapter__test__test_case_failed "1"
  fi
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  posix_adapter__find "$base_path" --type 'f' --name 'dummy_file' | \
  posix_adapter__wc --lines \
)"
posix_adapter__test__assert_equal "$expected" "$result"

#==============================================================================
posix_adapter__test__valid_case 'rm - directory can be deleted - verbose'

base_path='fixtures/rm'
dummy_directory="${base_path}/dummy_directory"

posix_adapter__mkdir --parents "$dummy_directory"

if output="$(posix_adapter__rm --recursive --verbose "$dummy_directory")"
then
  if [ -z "$output" ]
  then
    posix_adapter__test__test_case_failed "1"
  fi
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  posix_adapter__find "$base_path" --type 'd' --name 'dummy_directory' | \
  posix_adapter__wc --lines \
)"
posix_adapter__test__assert_equal "$expected" "$result"

#==============================================================================
posix_adapter__test__valid_case 'rm - non-existent file can be ignored with force - verbose'

base_path='fixtures/rm'
dummy_file="${base_path}/non-existent-file"

if output="$(posix_adapter__rm --force --verbose "$dummy_file")"
then
  # There should be no output if the file does not exist.
  if [ -z "$output" ]
  then
    posix_adapter__test__test_case_passed
  fi
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'rm - missing path should result in an error'

if error_message="$(posix_adapter__rm 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case \
  'rm - multiple paths should result in an error'

if error_message="$(posix_adapter__rm 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'rm - invalid option'

if error_message="$(posix_adapter__rm --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'rm - invalid option style'

if error_message="$(posix_adapter__rm -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
