#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'mkdir - default use case'

path='./fixtures/mkdir/temp_dir'

posix_adapter__rm --recursive --force "$path"

if posix_adapter__mkdir "$path"
then
  posix_adapter__test__test_case_passed
  posix_adapter__rm --recursive "$path"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'mkdir - parents flag'

if posix_adapter__mkdir --parents '../tests'
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'mkdir - missing path should result an error'

if error_message="$(posix_adapter__mkdir 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mkdir - multiple paths should result an error'

if error_message="$(posix_adapter__mkdir 'path1' 'path2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mkdir - invalid options'

if error_message="$(posix_adapter__mkdir --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'mkdir - invalid option style'

if error_message="$(posix_adapter__mkdir -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
