#==============================================================================
# TOOL: UNAME
#==============================================================================
title='uname :: parameter checking'
# if dm_tools__uname -s -r -m >/dev/null 2>&1
if dm_tools__uname --kernel-name --kernel-release --machine >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi


