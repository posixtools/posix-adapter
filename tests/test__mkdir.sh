#==============================================================================
# TOOL: MKDIR
#==============================================================================
title='mkdir :: parents flag'
if dm_tools__mkdir --parents ../tests
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi
