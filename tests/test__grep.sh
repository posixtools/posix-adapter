#==============================================================================
title='grep :: extended regexp mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep -E 'l+')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='grep :: silent mode'

expected=''

if result="$(dm_tools__echo "hello" | dm_tools__grep --silent '.')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='grep :: inverted mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep --invert-match 'imre')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='grep :: count mode'

expected='1'

if result="$(dm_tools__echo "hello" | dm_tools__grep --count 'l')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='grep :: only matching mode'

expected='ll'

if result="$( \
  dm_tools__echo "imre hello" | dm_tools__grep --only-matching 'll' \
)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
