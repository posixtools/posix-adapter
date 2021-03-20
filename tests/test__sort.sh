#==============================================================================
# TOOL: SORT
#==============================================================================
title='sort :: parameter checking'
if dm_tools__echo 'hello' | dm_tools__sort --zero-terminated --dictionary-order >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

