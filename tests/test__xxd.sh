#==============================================================================
title='xxd :: encode'

expected='68656c6c6f0a'

if result="$( dm_tools__echo 'hello' | dm_tools__xxd -plain)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='xxd :: decode'

expected='hello'

if result="$( dm_tools__echo '68656c6c6f0a' | dm_tools__xxd -plain -reverse)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
