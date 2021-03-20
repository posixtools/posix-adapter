#==============================================================================
title='xargs :: placeholder and additional parameters'

expected='hello'

if result="$( dm_tools__echo 'hello' | dm_tools__xargs -I {} echo {} )"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='xargs :: null terminated'

expected='hello'

if result="$( dm_tools__echo 'hello' | dm_tools__xargs --null)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='xargs :: arg length 1'

expected='hello'

if result="$( dm_tools__echo 'hello' | dm_tools__xargs --max-args 1)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='xargs :: arg length 2'

expected='hello'

if result="$( dm_tools__echo 'hello' | dm_tools__xargs --max-args 1)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
