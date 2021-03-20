#==============================================================================
title='dirname :: dir name can be retrieved'

data='/this/is/a/path'
expected='/this/is/a'

if result="$(dm_tools__dirname "$data")"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
