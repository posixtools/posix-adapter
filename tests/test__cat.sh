#==============================================================================
title='cat :: basic functionality'

path='./fixtures/cat/dummy_file'
expected='dummy content'

if result="$(dm_tools__cat "$path")"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

