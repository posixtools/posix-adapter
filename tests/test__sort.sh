#==============================================================================
title='sort :: parameter checking'

if ( \
  dm_tools__echo 'hello' | \
  dm_tools__sort --zero-terminated --dictionary-order >/dev/null 2>&1 \
)
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

