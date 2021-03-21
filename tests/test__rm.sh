#==============================================================================
title='rm :: recursive and force mode'

expected=''

if result="$( \
  dm_tools__rm \
    --recursive \
    --force \
    'something-that-surely-does-not-exist-123456789'
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

