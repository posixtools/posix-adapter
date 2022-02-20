#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'rm - file can be deleted'

base_path='fixtures/rm'
dummy_file="${base_path}/dummy_file"

dm_tools__touch "$dummy_file"

if ! dm_tools__rm "$dummy_file"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  dm_tools__find "$base_path" --type 'f' --name 'dummy_file' | \
  dm_tools__wc --lines \
)"
dm_tools__test__assert_equal "$expected" "$result"

#==============================================================================
dm_tools__test__valid_case 'rm - directory can be deleted'

base_path='fixtures/rm'
dummy_directory="${base_path}/dummy_directory"

dm_tools__mkdir --parents "$dummy_directory"

if ! dm_tools__rm --recursive "$dummy_directory"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  dm_tools__find "$base_path" --type 'd' --name 'dummy_directory' | \
  dm_tools__wc --lines \
)"
dm_tools__test__assert_equal "$expected" "$result"

#==============================================================================
dm_tools__test__valid_case 'rm - non-existent file can be ignored with force'

base_path='fixtures/rm'
dummy_file="${base_path}/non-existent-file"

if dm_tools__rm --force "$dummy_file"
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'rm - file can be deleted - verbose'

base_path='fixtures/rm'
dummy_file="${base_path}/dummy_file"

dm_tools__touch "$dummy_file"

if output="$(dm_tools__rm --verbose "$dummy_file")"
then
  if [ -z "$output" ]
  then
    dm_tools__test__test_case_failed "1"
  fi
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  dm_tools__find "$base_path" --type 'f' --name 'dummy_file' | \
  dm_tools__wc --lines \
)"
dm_tools__test__assert_equal "$expected" "$result"

#==============================================================================
dm_tools__test__valid_case 'rm - directory can be deleted - verbose'

base_path='fixtures/rm'
dummy_directory="${base_path}/dummy_directory"

dm_tools__mkdir --parents "$dummy_directory"

if output="$(dm_tools__rm --recursive --verbose "$dummy_directory")"
then
  if [ -z "$output" ]
  then
    dm_tools__test__test_case_failed "1"
  fi
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

expected='0'
result="$( \
  dm_tools__find "$base_path" --type 'd' --name 'dummy_directory' | \
  dm_tools__wc --lines \
)"
dm_tools__test__assert_equal "$expected" "$result"

#==============================================================================
dm_tools__test__valid_case 'rm - non-existent file can be ignored with force - verbose'

base_path='fixtures/rm'
dummy_file="${base_path}/non-existent-file"

if output="$(dm_tools__rm --force --verbose "$dummy_file")"
then
  # There should be no output if the file does not exist.
  if [ -z "$output" ]
  then
    dm_tools__test__test_case_passed
  fi
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'rm - missing path should result in an error'

if error_message="$(dm_tools__rm 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'rm - multiple paths should result in an error'

if error_message="$(dm_tools__rm 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'rm - invalid option'

if error_message="$(dm_tools__rm --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'rm - invalid option style'

if error_message="$(dm_tools__rm -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
