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
posix_adapter__test__valid_case 'find - full parameter space - case 000000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='6'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 000000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 00001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='6'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 00010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    \
    --name 'file_a*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 00011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 00100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='4'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    --type 'f' \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 00101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='4'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 00110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    \
    --type 'f' \
    --name 'file_a*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 00111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 00111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 01000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='5'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --max-depth '1' \
    \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 01001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  1
# ├── dir               1
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='5'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 01010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --max-depth '1' \
    \
    --name 'file_a*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 01011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 01100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='3'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --max-depth '1' \
    --type 'f' \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 01101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          1
expected='3'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 01110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
    --max-depth '1' \
    --type 'f' \
    --name 'file_a*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 01111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      0
# ├── file_a_1          1
# ├── file_a_2          1
# └── file_b_1          0
expected='2'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 01111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    \
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
posix_adapter__test__valid_case 'find - full parameter space - case 10000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 10001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 10010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    \
    --name 'file_c*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 10011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    \
    --name 'file_c*' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 10100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    --type 'f' \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 10101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 10110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    --type 'f' \
    --name 'file_c*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 10111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 10111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    \
    --type 'f' \
    --name 'file_c*' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 11000'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11000
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 11001'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11001
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 11010'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11010
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    \
    --name 'file_c*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 11011'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11011
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    \
    --name 'file_c*' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 11100'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11100
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    --type 'f' \
    \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 11101'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11101
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
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
posix_adapter__test__valid_case 'find - full parameter space - case 11110'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11110
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    --type 'f' \
    --name 'file_c*' \
    \
  | posix_adapter__tr --replace '\0' ' ' 2>&1 | posix_adapter__wc --words 2>&1 \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'find - full parameter space - case 11111'

find_base_dir='./fixtures/find'

# tests/fixtures/find/  0
# ├── dir               0
# │   └── file_c_1      1
# ├── file_a_1          0
# ├── file_a_2          0
# └── file_b_1          0
expected='1'

# ,------- min_depth
# |,------ max_depth
# ||,----- type
# |||,---- name
# |||||,-- print0
# 11111
if result="$( \
  posix_adapter__find "$find_base_dir" 2>&1 \
    --min-depth '2' \
    --max-depth '2' \
    --type 'f' \
    --name 'file_c*' \
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
