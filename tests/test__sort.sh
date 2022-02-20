#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'sort - parameter checking 1'

if ( \
  dm_tools__echo 'hello' | \
  dm_tools__sort >/dev/null \
)
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sort - parameter checking 2'

if ( \
  dm_tools__echo 'hello' | dm_tools__sort --dictionary-order >/dev/null \
)
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sort - parameter checking 3'

if ( \
  dm_tools__printf 'hello' | dm_tools__sort --zero-terminated >/dev/null \
)
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sort - parameter checking 4'

if ( \
  dm_tools__echo 'hello' | \
  dm_tools__sort --zero-terminated --dictionary-order >/dev/null \
)
then
  dm_tools__test__test_case_passed
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case \
  'sort - multiple paths should result in an error'

if error_message="$(dm_tools__sort 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'sort - invalid option'

if error_message="$(dm_tools__sort --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'sort - invalid option style'

if error_message="$(dm_tools__sort -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
