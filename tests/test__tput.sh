#==============================================================================
title='tput :: tput call can be executed'

if dm_tools__tput longname >/dev/null 2>&1
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
