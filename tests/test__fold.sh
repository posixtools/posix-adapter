#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'fold - no parameters'

# No wrapping should happen.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$(echo "$input_line" | posix_adapter__fold)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w] line is shorter than the limit'

# No wrapping should happen as the input line is shorter than the wrapping
# limit.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$(echo "$input_line" | posix_adapter__fold --width '24')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w] line the same as the limit'

# Wrapping should not happen as the width limit is the same as line width.
input_line='value_1 value_2 value_3'
#                                 ^- limit is here
expected='value_1 value_2 value_3'

if result="$(echo "$input_line" | posix_adapter__fold --width '23')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w] line is longer than the limit'

# Wrapping should happen as the line is longer than the limit.
input_line='value_1 value_2 value_3'
#                                ^- limit is here
expected="$( \
  echo 'value_1 value_2 value_'; \
  echo '3'; \
)"

if result="$(echo "$input_line" | posix_adapter__fold --width '22')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w] multiline input should be handled'

#      |<-------20--------->|
input_line="$( \
  echo 'This is the first line.'; \
  echo 'And this is the second line.'; \
  echo 'Oh, we have another line too!'; \
)"
expected="$( \
  echo 'This is the first li'; \
  echo 'ne.'; \
  echo 'And this is the seco'; \
  echo 'nd line.'; \
  echo 'Oh, we have another '; \
  echo 'line too!'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$(echo "$input_line" | posix_adapter__fold --width '20')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w,s] line is shorter than the limit'

# No wrapping should happen as the input line is shorter than the wrapping
# limit.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$( \
  echo "$input_line" | posix_adapter__fold --spaces --width '24' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w,s] line the same as the limit'

# Wrapping should not happen as the width limit is the same as line width.
input_line='value_1 value_2 value_3'
#                                 ^- limit is here
expected='value_1 value_2 value_3'

if result="$( \
  echo "$input_line" | posix_adapter__fold --spaces --width '23' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w,s] line is longer than the limit'

# Wrapping should happen as the line is longer than the limit.
input_line='value_1 value_2 value_3'
#                                ^- limit is here
expected="$( \
  echo 'value_1 value_2 '; \
  echo 'value_3'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$( \
  echo "$input_line" | posix_adapter__fold --spaces --width '22' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'fold - [w,s] multiline input should be handled'

input_line="$( \
  echo 'This is the first line.'; \
  echo 'And this is the second line.'; \
  echo 'Oh, we have another line too!'; \
)"
expected="$( \
  echo 'This is the first '; \
  echo 'line.'; \
  echo 'And this is the '; \
  echo 'second line.'; \
  echo 'Oh, we have another '; \
  echo 'line too!'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$( \
  echo "$input_line" | posix_adapter__fold --spaces --width '20' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'fold - positional argument'

if error_message="$(posix_adapter__fold 'positional' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'fold - invalid option'

if error_message="$(posix_adapter__fold --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'fold - invalid option style'

if error_message="$(posix_adapter__fold -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
