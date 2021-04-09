#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'sed - [stdin] append prefix before line'

expected='prefix - hello'

if result="$(dm_tools__echo 'hello' | dm_tools__sed --expression 's/^/prefix - /')"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [path] append prefix before line'

path='fixtures/sed/dummy_file_1'
expected='prefix - hello'

if result="$(dm_tools__sed --expression 's/^/prefix - /' "$path")"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [stdin] remove digits only'

expected='and other text'

if result="$( \
  dm_tools__echo '42 and other text' | \
  dm_tools__sed --extended --expression 's/^[[:digit:]]+[[:space:]]*//' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [path] remove digits only'

path='fixtures/sed/dummy_file_2'
expected='and other text'

if result="$( \
  dm_tools__sed --extended --expression 's/^[[:digit:]]+[[:space:]]*//' "$path" \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [stdin] select line'

expected='line 2'

if result="$( \
  ( \
    dm_tools__echo 'line 1'; \
    dm_tools__echo 'line 2'; \
    dm_tools__echo 'line 3' \
  ) | dm_tools__sed --expression '2q;d' \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [path] select line'

path='fixtures/sed/dummy_file_3'
expected='line 2'

if result="$( \
  dm_tools__sed --expression '2q;d' "$path" \
)"
then
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'sed - [path] inplace edit without backup'

file_name='dummy_file_inplace'
path="fixtures/sed/${file_name}"
expected_original='hello'
expected_edited='world'

# Current content
dm_tools__echo "$expected_original" > "$path"

if ! dm_tools__sed --in-place '' --expression "s/hello/world/" "$path"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

dm_tools__test__assert_equal "$expected_edited" "$(dm_tools__cat "$path")"

dm_tools__rm "$path"

#==============================================================================
dm_tools__test__valid_case 'sed - [path] inplace edit with backup'

file_name='dummy_file_inplace'
path="fixtures/sed/${file_name}"
suffix='.backup'
expected_original='hello'
expected_edited='world'

# Current content
dm_tools__echo "$expected_original" > "$path"

if ! dm_tools__sed --in-place '.backup' --expression "s/hello/world/" "$path"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
fi

dm_tools__test__assert_equal "$expected_edited" "$(dm_tools__cat "$path")"

dm_tools__rm "$path"
# If the backup file can be deleted wihtout any error, it was there.
dm_tools__rm "${path}${suffix}"

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'sed - expression is mandatory'

if error_message="$(dm_tools__sed 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
#==============================================================================
dm_tools__test__error_case 'sed - multiple paths should result in an error'

if error_message="$(dm_tools__sed --expression '' 'path_1' 'path_2' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'sed - invalid option'

if error_message="$(dm_tools__sed --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'sed - invalid option style'

if error_message="$(dm_tools__sed -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
