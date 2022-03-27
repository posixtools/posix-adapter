#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
# printf is only present in this library to check if all the required
# functionalities are present in all platforms.
posix_adapter__test__valid_case 'printf - minimum width specifier'

expected=' 42'

if result="$(posix_adapter__printf '%*s' '3' '42')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'printf - precision specifier'

expected='123'

if result="$(posix_adapter__printf '%.*s' '3' '123456')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'printf - combined minimum width and precision specifier'

expected=' 123'

if result="$(posix_adapter__printf '%*.*s' '4' '3' '123456')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi
