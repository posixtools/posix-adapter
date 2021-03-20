#==============================================================================
# TOOL: GREP
#==============================================================================
title='grep :: extended regexp mode'
expected='hello'
if result="$(dm_tools__echo "hello" | dm_tools__grep -E 'l+')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'ineffective extended regexp mode'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='grep :: silent mode'
expected=''
if result="$(dm_tools__echo "hello" | dm_tools__grep --silent '.')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'ineffective --silent flag'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='grep :: inverted mode'
expected='hello'
if result="$(dm_tools__echo "hello" | dm_tools__grep --invert-match 'imre')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'ineffective --invert-match flag'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='grep :: count mode'
expected='1'
if result="$(dm_tools__echo "hello" | dm_tools__grep --count 'l')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'ineffective --count flag'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='grep :: only matching mode'
expected='ll'
if result="$(dm_tools__echo "imre hello" | dm_tools__grep --only-matching 'll')"
then
  if [ "$result" = "$expected" ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'ineffective --only-matching flag'
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi
