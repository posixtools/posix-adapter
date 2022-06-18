#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'ln - link can be created'

base_path='./fixtures/ln'
path_to_target="${base_path}/target"
path_to_link="${base_path}/dummy_link"

posix_adapter__rm --force "$path_to_link"

if posix_adapter__ln --path-to-target "$path_to_target" --path-to-link "$path_to_link"
then
  # With the hard link there should be two matches.
  expected='2'
  result="$( \
    posix_adapter__find "$base_path" --type 'f' --same-file "$path_to_target" | \
    posix_adapter__wc --lines \
  )"
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

posix_adapter__rm --force "$path_to_link"

#==============================================================================
posix_adapter__test__valid_case 'ln - symbolic link can be created'

base_path='./fixtures/ln'
path_to_target="${base_path}/target"
path_to_link="${base_path}/dummy_link"

posix_adapter__rm --force "$path_to_link"

if posix_adapter__ln --symbolic --path-to-target "$path_to_target" --path-to-link "$path_to_link"
then
  # One symbolic link should be created.
  expected='1'
  result="$( \
    posix_adapter__find "$base_path" --type 'l' | \
    posix_adapter__wc --lines \
  )"
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

posix_adapter__rm --force "$path_to_link"

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'ln - does not take positional agruments'

if error_message="$(posix_adapter__ln 'some_argument' 2>&1)"
then
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'ln - invalid option'

if error_message="$(posix_adapter__ln --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'ln - invalid option style'

if error_message="$(posix_adapter__ln -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
