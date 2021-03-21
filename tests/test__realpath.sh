#==============================================================================
title='realpath :: no symlink mode'

if dm_tools__realpath --no-symlink . >/dev/null 2>&1
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

