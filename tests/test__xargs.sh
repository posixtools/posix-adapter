#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'xargs - placeholder and additional parameters'

expected='hello'

if result="$(dm_tools__echo 'hello' | dm_tools__xargs --replace {} echo {} )"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'xargs - null terminated'

expected='hello'

if result="$(dm_tools__echo 'hello' | dm_tools__xargs --null)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'xargs - arg length 1 line will be broken up'

expected='2'

if result="$( \
  dm_tools__echo 'hello imre' | \
  dm_tools__xargs --max-args 1 | \
  dm_tools__wc --lines \
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
dm_tools__test__error_case 'xargs - invalid options'

if error_message="$(dm_tools__xargs --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'xargs - invalid option style'

if error_message="$(dm_tools__xargs -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
