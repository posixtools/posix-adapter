#==============================================================================
title='basename :: basename can be retrieved'

data='/this/is/a/path'
expected='path'

if result="$(dm_tools__basename "$data")"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
