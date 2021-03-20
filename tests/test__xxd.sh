#==============================================================================
# TOOL: XXD
#==============================================================================
title='xxd :: encode'
expected='68656c6c6f0a'
if result="$( dm_tools__echo 'hello' | dm_tools__xxd -plain)"
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

title='xxd :: decode'
expected='hello'
if result="$( dm_tools__echo '68656c6c6f0a' | dm_tools__xxd -plain -reverse)"
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
