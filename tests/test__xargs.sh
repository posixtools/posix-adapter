#==============================================================================
# TOOL: XARGS
#==============================================================================
title='xargs :: placeholder and additional parameters'
expected='hello'
if result="$( dm_tools__echo 'hello' | dm_tools__xargs -I {} echo {} )"
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

title='xargs :: null terminated'
expected='hello'
if result="$( dm_tools__echo 'hello' | dm_tools__xargs --null)"
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

title='xargs :: arg length 1'
expected='hello'
if result="$( dm_tools__echo 'hello' | dm_tools__xargs --max-args 1)"
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

title='xargs :: arg length 2'
expected='hello'
if result="$( dm_tools__echo 'hello' | dm_tools__xargs --max-args 1)"
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
