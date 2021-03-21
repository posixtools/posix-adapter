#==============================================================================
title='readlink :: canonicalize mode'

if dm_tools__readlink -f . >/dev/null 2>&1
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

