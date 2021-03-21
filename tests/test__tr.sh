#==============================================================================
title='tr :: delete newline'

expected='abc'

if result="$( \
  ( \
    dm_tools__echo 'a'; \
    dm_tools__echo 'b'; \
    dm_tools__echo 'c' \
  ) | dm_tools__tr --delete '\n' \
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
