#==============================================================================
# TOOL: READLINK
#==============================================================================
title='readlink :: canonicalize mode'
if dm_tools__readlink -f . >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

