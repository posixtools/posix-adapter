#==============================================================================
# TOOL: SED
#==============================================================================
title='sed :: append prefix before line'
expected='prefix - hello'
if result="$(dm_tools__echo 'hello' | dm_tools__sed 's/^/prefix - /')"
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

title='sed :: remove digits only'
expected='and other text'
if result="$(dm_tools__echo '42 and other text' | dm_tools__sed -Ee 's/^[[:digit:]]+[[:space:]]*//')"
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

title='sed :: select line'
expected='line 2'
if result="$( ( dm_tools__echo 'line 1'; dm_tools__echo 'line 2'; dm_tools__echo 'line 3' ) | dm_tools__sed '2q;d')"
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

