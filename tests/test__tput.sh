#==============================================================================
title='tput :: tput call can be executed'

# Have to check if tput is available because some test runners don't have it.
if command -v tput >/dev/null 2>&1 && tput init >/dev/null 2>&1
then
  if dm_tools__tput longname >/dev/null 2>&1
  then
    dm_tools__log_success "$title"
  else
    status="$?"
    dm_tools__failure "$title" "$status"
  fi
fi
