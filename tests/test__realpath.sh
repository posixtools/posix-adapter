#==============================================================================
title='realpath :: no symlink mode'

if dm_tools__realpath --no-symlink . >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

