#==============================================================================
title='cat :: basic functionality'

path='./fixtures/cat/dummy_file'
expected='dummy content'

if result="$(dm_tools__cat "$path")"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

