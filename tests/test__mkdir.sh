#==============================================================================
title='mkdir :: parents flag'

if dm_tools__mkdir --parents ../tests
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
