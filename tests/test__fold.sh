#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'fold - no parameters'

# No wrapping should happen.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$(dm_tools__echo "$input_line" | dm_tools__fold)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w] line is shorter than the limit'

# No wrapping should happen as the input line is shorter than the wrapping
# limit.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$(dm_tools__echo "$input_line" | dm_tools__fold --width '24')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w] line the same as the limit'

# Wrapping should not happen as the width limit is the same as line width.
input_line='value_1 value_2 value_3'
#                                 ^- limit is here
expected='value_1 value_2 value_3'

if result="$(dm_tools__echo "$input_line" | dm_tools__fold --width '23')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w] line is longer than the limit'

# Wrapping should happen as the line is longer than the limit.
input_line='value_1 value_2 value_3'
#                                ^- limit is here
expected="$( \
  dm_tools__echo 'value_1 value_2 value_'; \
  dm_tools__echo '3'; \
)"

if result="$(dm_tools__echo "$input_line" | dm_tools__fold --width '22')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w] multiline input should be handled'

#                |<-------20--------->|
input_line="$( \
  dm_tools__echo 'This is the first line.'; \
  dm_tools__echo 'And this is the second line.'; \
  dm_tools__echo 'Oh, we have another line too!'; \
)"
expected="$( \
  dm_tools__echo 'This is the first li'; \
  dm_tools__echo 'ne.'; \
  dm_tools__echo 'And this is the seco'; \
  dm_tools__echo 'nd line.'; \
  dm_tools__echo 'Oh, we have another '; \
  dm_tools__echo 'line too!'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$(dm_tools__echo "$input_line" | dm_tools__fold --width '20')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w,s] line is shorter than the limit'

# No wrapping should happen as the input line is shorter than the wrapping
# limit.
input_line='value_1 value_2 value_3'
expected='value_1 value_2 value_3'

if result="$( \
  dm_tools__echo "$input_line" | dm_tools__fold --spaces --width '24' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w,s] line the same as the limit'

# Wrapping should not happen as the width limit is the same as line width.
input_line='value_1 value_2 value_3'
#                                 ^- limit is here
expected='value_1 value_2 value_3'

if result="$( \
  dm_tools__echo "$input_line" | dm_tools__fold --spaces --width '23' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w,s] line is longer than the limit'

# Wrapping should happen as the line is longer than the limit.
input_line='value_1 value_2 value_3'
#                                ^- limit is here
expected="$( \
  dm_tools__echo 'value_1 value_2 '; \
  dm_tools__echo 'value_3'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$( \
  dm_tools__echo "$input_line" | dm_tools__fold --spaces --width '22' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'fold - [w,s] multiline input should be handled'

input_line="$( \
  dm_tools__echo 'This is the first line.'; \
  dm_tools__echo 'And this is the second line.'; \
  dm_tools__echo 'Oh, we have another line too!'; \
)"
expected="$( \
  dm_tools__echo 'This is the first '; \
  dm_tools__echo 'line.'; \
  dm_tools__echo 'And this is the '; \
  dm_tools__echo 'second line.'; \
  dm_tools__echo 'Oh, we have another '; \
  dm_tools__echo 'line too!'; \
)"
# Note that the fold command does not remove trailing spaces!

if result="$( \
  dm_tools__echo "$input_line" | dm_tools__fold --spaces --width '20' \
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
dm_tools__test__error_case 'fold - positional argument'

if error_message="$(dm_tools__fold 'positional' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'fold - invalid option'

if error_message="$(dm_tools__fold --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'fold - invalid option style'

if error_message="$(dm_tools__fold -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
