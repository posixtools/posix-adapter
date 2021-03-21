#==============================================================================
title='grep :: extended regexp mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep -E 'l+')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='grep :: silent mode'

expected=''

if result="$(dm_tools__echo "hello" | dm_tools__grep --silent '.')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='grep :: inverted mode'

expected='hello'

if result="$(dm_tools__echo "hello" | dm_tools__grep --invert-match 'imre')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='grep :: count mode'

expected='1'

if result="$(dm_tools__echo "hello" | dm_tools__grep --count 'l')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='grep :: only matching mode'

expected='ll'

if result="$( \
  dm_tools__echo "imre hello" | dm_tools__grep --only-matching 'll' \
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
