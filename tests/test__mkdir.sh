#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'mkdir - default use case'

path='./fixtures/mkdir/temp_dir'

dm_tools__rm --recursive --force "$path"

if dm_tools__mkdir "$path"
then
  dm_tools__test__test_case_passed
  dm_tools__rm --recursive "$path"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'mkdir - parents flag'

if dm_tools__mkdir --parents '../tests'
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'mkdir - missing path should result an error'

if error_message="$(dm_tools__mkdir 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mkdir - multiple paths should result an error'

if error_message="$(dm_tools__mkdir 'path1' 'path2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mkdir - invalid options'

if error_message="$(dm_tools__mkdir --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mkdir - invalid option style'

if error_message="$(dm_tools__mkdir -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
