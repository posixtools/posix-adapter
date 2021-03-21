#==============================================================================
title='touch :: file can be created'

path='./fixtures/touch/dummy_file'

if dm_tools__touch "$path"
then
  dm_tools__log_success "$title"
  dm_tools__rm "$path"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
