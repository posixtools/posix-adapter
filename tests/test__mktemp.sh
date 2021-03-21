#==============================================================================
title='mktemp :: temp directory can be created'

path='./fixtures/mktemp'
template='dummy_temp.XXXXXX'

if result="$(dm_tools__mktemp --directory --tmpdir "$path" "$template")"
then
  dm_tools__log_success "$title"
  ls -la "$path"
  dm_tools__rm --recursive "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
