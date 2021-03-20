#==============================================================================
# TOOL: DATE
#==============================================================================
title='date :: generated timestamp is numbers only'
if result="$(dm_tools__date +'%s%N')"
then
  if dm_tools__echo "$result" | dm_tools__grep --silent -E '[[:digit:]]+'
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'should have generated only digits'
    log_failure "failed result: '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

