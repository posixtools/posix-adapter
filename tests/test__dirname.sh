#==============================================================================
title='dirname :: dir name can be retrieved'

data='/this/is/a/path'
expected='/this/is/a'

if result="$(dm_tools__dirname "$data")"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
