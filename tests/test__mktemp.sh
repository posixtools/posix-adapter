#==============================================================================
# VALID CASES
#==============================================================================
dm_tools__test__valid_case 'mktemp - temp file can be created'

path='./fixtures/mktemp'
template_base='dummy_temp'
template="${template_base}.XXXXXX"

# Created temp file and the .gitkeep file.
expected='2'

if dm_tools__mktemp --tmpdir "$path" "$template" >/dev/null
then
  result="$(dm_tools__find "$path" --type 'f' | dm_tools__wc --lines)"
  dm_tools__rm ${path}/${template_base}.*
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__rm --force ${path}/${template_base}.*
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
dm_tools__test__valid_case 'mktemp - temp directory can be created'

path='./fixtures/mktemp'
template_base='dummy_temp'
template="${template_base}.XXXXXX"

# Containing direcotry + temporary directory. Find's stuff..
expected='2'

if dm_tools__mktemp --directory --tmpdir "$path" "$template" >/dev/null
then
  result="$(dm_tools__find "$path" --type 'd' | dm_tools__wc --lines)"
  dm_tools__rm --recursive ${path}/${template_base}.*
  dm_tools__test__assert_equal "$expected" "$result"
else
  status="$?"
  dm_tools__rm --recursive --force ${path}/${template_base}.*
  dm_tools__test__test_case_failed "$status"
fi

#==============================================================================
# ERROR CASES
#==============================================================================
dm_tools__test__error_case 'mktemp - missing pattern should result in an error'

if error_message="$(dm_tools__mktemp 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case \
  'mktemp - multiple templates should result in an error'

if error_message="$(dm_tools__mktemp 'one' 'two' 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mktemp - invalid option'

if error_message="$(dm_tools__mktemp --option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi

#==============================================================================
dm_tools__test__error_case 'mktemp - invalid option style'

if error_message="$(dm_tools__mktemp -option 2>&1)"
then
  status="$?"
  dm_tools__test__test_case_failed "$status"
else
  status="$?"
  dm_tools__test__assert_invalid_parameters "$status" "$error_message"
fi
