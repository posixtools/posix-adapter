#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'sort - parameter checking 1'

if ( \
  echo 'hello' | \
  posix_adapter__sort >/dev/null \
)
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sort - parameter checking 2'

if ( \
  echo 'hello' | posix_adapter__sort --dictionary-order >/dev/null \
)
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sort - parameter checking 3'

if ( \
  posix_adapter__printf 'hello' | posix_adapter__sort --zero-terminated >/dev/null \
)
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sort - parameter checking 4'

if ( \
  echo 'hello' | \
  posix_adapter__sort --zero-terminated --dictionary-order >/dev/null \
)
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case \
  'sort - multiple paths should result in an error'

if error_message="$(posix_adapter__sort 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'sort - invalid option'

if error_message="$(posix_adapter__sort --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'sort - invalid option style'

if error_message="$(posix_adapter__sort -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
