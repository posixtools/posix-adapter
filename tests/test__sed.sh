#!/bin/sh
#==============================================================================
# VALID CASES
#==============================================================================
posix_adapter__test__valid_case 'sed - [stdin] append prefix before line'

expected='prefix - hello'

if result="$(posix_adapter__echo 'hello' | posix_adapter__sed --expression 's/^/prefix - /')"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [path] append prefix before line'

path='fixtures/sed/dummy_file_1'
expected='prefix - hello'

if result="$(posix_adapter__sed --expression 's/^/prefix - /' "$path")"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [stdin] remove digits only'

expected='and other text'

if result="$( \
  posix_adapter__echo '42 and other text' | \
  posix_adapter__sed --extended --expression 's/^[[:digit:]]+[[:space:]]*//' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [path] remove digits only'

path='fixtures/sed/dummy_file_2'
expected='and other text'

if result="$( \
  posix_adapter__sed --extended --expression 's/^[[:digit:]]+[[:space:]]*//' "$path" \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [stdin] select line'

expected='line 2'

if result="$( \
  ( \
    posix_adapter__echo 'line 1'; \
    posix_adapter__echo 'line 2'; \
    posix_adapter__echo 'line 3' \
  ) | posix_adapter__sed --expression '2q;d' \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [path] select line'

path='fixtures/sed/dummy_file_3'
expected='line 2'

if result="$( \
  posix_adapter__sed --expression '2q;d' "$path" \
)"
then
  posix_adapter__test__assert_equal "$expected" "$result"
else
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

#==============================================================================
posix_adapter__test__valid_case 'sed - [path] inplace edit without backup'

file_name='dummy_file_inplace'
path="fixtures/sed/${file_name}"
expected_original='hello'
expected_edited='world'

# Current content
posix_adapter__echo "$expected_original" > "$path"

if ! posix_adapter__sed --in-place '' --expression "s/hello/world/" "$path"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

posix_adapter__test__assert_equal "$expected_edited" "$(posix_adapter__cat "$path")"

posix_adapter__rm "$path"

#==============================================================================
posix_adapter__test__valid_case 'sed - [path] inplace edit with backup'

file_name='dummy_file_inplace'
path="fixtures/sed/${file_name}"
suffix='.backup'
expected_original='hello'
expected_edited='world'

# Current content
posix_adapter__echo "$expected_original" > "$path"

if ! posix_adapter__sed --in-place '.backup' --expression "s/hello/world/" "$path"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
fi

posix_adapter__test__assert_equal "$expected_edited" "$(posix_adapter__cat "$path")"

posix_adapter__rm "$path"
# If the backup file can be deleted wihtout any error, it was there.
posix_adapter__rm "${path}${suffix}"

#==============================================================================
# ERROR CASES
#==============================================================================
posix_adapter__test__error_case 'sed - expression is mandatory'

if error_message="$(posix_adapter__sed 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
#==============================================================================
posix_adapter__test__error_case 'sed - multiple paths should result in an error'

if error_message="$(posix_adapter__sed --expression '' 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'sed - invalid option'

if error_message="$(posix_adapter__sed --option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
posix_adapter__test__error_case 'sed - invalid option style'

if error_message="$(posix_adapter__sed -option 2>&1)"
then
  status="$?"
  posix_adapter__test__test_case_failed "$status"
else
  status="$?"
  posix_adapter__test__assert_invalid_parameters "$status" "$error_message"
fi
