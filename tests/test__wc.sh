#==============================================================================
# TOOL: WC
#==============================================================================
title='wc :: lines'
expected='3'
if result="$( ( dm_tools__echo 'a'; dm_tools__echo 'b'; dm_tools__echo 'c' ) | dm_tools__wc --lines)"
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

title='wc :: chars'
expected='12' # 11 character + 1 newline
if result="$( dm_tools__echo 'this is ok!' | dm_tools__wc --chars)"
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
