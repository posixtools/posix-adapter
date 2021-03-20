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
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

