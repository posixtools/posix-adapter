#==============================================================================
title='xxd :: encode'

expected='68656c6c6f0a'

if result="$( dm_tools__echo 'hello' | dm_tools__xxd -plain)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='xxd :: decode'

expected='hello'

if result="$( dm_tools__echo '68656c6c6f0a' | dm_tools__xxd -plain -reverse)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
