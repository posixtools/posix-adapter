#==============================================================================
title='basename :: basename can be retrieved'

data='/this/is/a/path'
expected='path'

if result="$(dm_tools__basename "$data")"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
