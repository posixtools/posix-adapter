#!/bin/sh

# These tests are working on the provided fixtures:
# tests/fixtures/find/
# ├── dir
# │   └── file_c_1
# ├── file_a_1
# ├── file_a_2
# └── file_b_1

#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'find - default path parameter'

if posix_adapter__find >/dev/null
then
  posix_adapter__test__test_case_passed
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic file search'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='6'

if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic file search by type'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='4'

if result="$( \
  posix_adapter__find "$find_base_dir" --type 'f' 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic file search by type and maxdepth'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='3'

if result="$( \
  posix_adapter__find "$find_base_dir" --type 'f' --max-depth '1' 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic file search by name and type'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

if result="$( \
  posix_adapter__find "$find_base_dir" --type 'f' --name 'file_a*' 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic file search by name zero terminated'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# Same result as before but zero terminated -> only one line should be found.
if result="$( \
  posix_adapter__find "$find_base_dir" --type 'f' --name 'file_a*' --print0 2>&1 | \
  posix_adapter__tr --replace '\0' ' ' | posix_adapter__wc --words \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic directory search by type'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='2'

if result="$( \
  posix_adapter__find "$find_base_dir" --type 'd' 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - basic directory search by name zero terminated'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

if result="$( \
  posix_adapter__find "$find_base_dir" --type 'd' --name 'find' 2>&1 | \
  posix_adapter__wc --lines \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='6'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='6'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    --name 'file_a*' \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    --name 'file_a*' \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='4'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --type 'f' \
    \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='4'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --type 'f' \
    \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --type 'f' \
    --name 'file_a*' \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 0111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 0111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --type 'f' \
    --name 'file_a*' \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='5'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    \
    \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='5'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    \
    \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    \
    --name 'file_a*' \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    \
    --name 'file_a*' \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='3'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    --type 'f' \
    \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='3'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    --type 'f' \
    \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    --type 'f' \
    --name 'file_a*' \
    \
  | posix_adapter__wc --lines 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 1111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,----- max_depth
# |,---- type
# ||,--- name
# |||,-- print0
# 1111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    --type 'f' \
    --name 'file_a*' \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - samefile'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
# Because of the same file flag, only one file would be found.
expected='1'

if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --max-depth '1' \
    --type 'f' \
    --name 'file_a*' \
    --same-file "${find_base_dir}/file_a_1" \
    --print0 \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
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
posix_adapter__test__error_case 'find - multiple paths should result an error'

if error_message="$(posix_adapter__find 'one' 'two' 2>&1)"
then
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'find - invalid option'

if error_message="$(posix_adapter__find --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'find - invalid option style'

if error_message="$(posix_adapter__find -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
