#==============================================================================
title='mkfifo :: fifo can be created'

path='./fixtures/mkfifo/dummy_fifo'

if dm_tools__mkfifo "$path"
then
  dm_tools__log_success "$title"
  dm_tools__rm "$path"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
