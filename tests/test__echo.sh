#==============================================================================
title='echo :: basic echo'

data='hello'
expected='hello'

if result="$(dm_tools__echo "$data")"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='echo :: multiline output'

expected='2'

if result="$( ( dm_tools__echo ''; dm_tools__echo '') | dm_tools__wc --lines)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='echo :: omitting trailing newline'

expected='1'

if result="$( ( dm_tools__echo -n ''; dm_tools__echo '' ) | dm_tools__wc --lines)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
