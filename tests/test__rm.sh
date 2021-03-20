#==============================================================================
# TOOL: RM
#==============================================================================
title='rm :: recursive and force mode'
expected=''
if result="$(dm_tools__rm --recursive --force 'something-that-surely-does-not-exist-123456789')"
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

