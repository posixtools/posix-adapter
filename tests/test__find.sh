#==============================================================================
title='find :: basic file search by name'

if dm_tools__find . -type 'f' -name '*' >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='find :: basic file search by name zero terminated'

if dm_tools__find . -type 'f' -name '*' -print0 >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='find :: basic direcroty search by name'

if dm_tools__find . -type 'd' -name '*' >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='find :: basic directory search by name zero terminated'

if dm_tools__find . -type 'd' -name '*' -print0 >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

