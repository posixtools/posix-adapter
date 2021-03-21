#==============================================================================
title='date :: generated timestamp is numbers only'

if result="$(dm_tools__date +'%s%N')"
then
  if dm_tools__echo "$result" | dm_tools__grep --silent -E '[[:digit:]]+'
  then
    dm_tools__log_success "$title"
  else
    dm_tools__log_failure "$title"
    dm_tools__log_failure 'should have generated only digits'
    dm_tools__log_failure "failed result: '${result}'"
    exit 1
  fi
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
