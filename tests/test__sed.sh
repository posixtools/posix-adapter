#==============================================================================
title='sed :: append prefix before line'

expected='prefix - hello'

if result="$(dm_tools__echo 'hello' | dm_tools__sed 's/^/prefix - /')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='sed :: remove digits only'

expected='and other text'

if result="$( \
  dm_tools__echo '42 and other text' | \
  dm_tools__sed -Ee 's/^[[:digit:]]+[[:space:]]*//' \
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='sed :: select line'

expected='line 2'

if result="$( \
  ( \
    dm_tools__echo 'line 1'; \
    dm_tools__echo 'line 2'; \
    dm_tools__echo 'line 3' \
  ) | dm_tools__sed '2q;d' \
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
