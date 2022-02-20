#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'ln - link can be created'

base_path='./fixtures/ln'
target="${base_path}/target"
link_name="${base_path}/dummy_link"

dm_tools__rm --force "$link_name"

if dm_tools__ln --target "$target" --link-name "$link_name"
then
  # With the hard link there should be two matches.
  expected='2'
  result="$( \
    dm_tools__find "$base_path" --type 'f' --same-file "$target" | \
    dm_tools__wc --lines \
  )"
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

dm_tools__rm --force "$link_name"

#==============================================================================
dm_tools__test__valid_case 'ln - symbolic link can be created'

base_path='./fixtures/ln'
target="${base_path}/target"
link_name="${base_path}/dummy_link"

dm_tools__rm --force "$link_name"

if dm_tools__ln --symbolic --target "$target" --link-name "$link_name"
then
  # One symbolic link should be created.
  expected='1'
  result="$( \
    dm_tools__find "$base_path" --type 'l' | \
    dm_tools__wc --lines \
  )"
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

dm_tools__rm --force "$link_name"

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'ln - does not take positional agruments'

if error_message="$(dm_tools__ln 'some_argument' 2>&1)"
then
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'ln - invalid option'

if error_message="$(dm_tools__ln --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'ln - invalid option style'

if error_message="$(dm_tools__ln -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
