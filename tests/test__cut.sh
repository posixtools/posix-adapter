#==============================================================================
title='cut :: delimiter and field selection'

data='one/two/three/four'
expected='two/three/four'

if result="$( \
  dm_tools__echo "$data" | dm_tools__cut --delimiter '/' --fields '2-' \
)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='cut :: character range selection'

data='123456789'
expected='12345'

if result="$(dm_tools__echo "$data" | dm_tools__cut --characters '1-5')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

