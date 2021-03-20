#==============================================================================
# TOOL: TR
#==============================================================================
title='tr :: delete newline'
expected='abc'
if result="$( ( dm_tools__echo 'a'; dm_tools__echo 'b'; dm_tools__echo 'c' ) | dm_tools__tr --delete '\n')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'unsupported feature'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi
