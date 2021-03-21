# These files are working on the provided fixtures:
# tests/fixtures/find/
# ├── file_a_1
# ├── file_a_2
# └── file_b_1

#==============================================================================
title='find :: basic file search by name'

expected='2'

if result="$( \
  dm_tools__find './fixtures/find' -type 'f' -name 'file_a*' | \
  dm_tools__wc --lines \
)"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='find :: basic file search by name zero terminated'

expected='1'

# Same result as before but zero terminated -> only one line should be found.
if result="$( \
  dm_tools__find './fixtures/find' -type 'f' -name 'file_a*' -print0 | \
  dm_tools__wc --lines \
)"
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='find :: basic direcroty search by name'

if dm_tools__find . -type 'd' -name '*' >/dev/null
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='find :: basic directory search by name zero terminated'

expected='1'

if result="$( \
  dm_tools__find './fixtures' -type 'd' -name 'find' | \
  dm_tools__wc --lines \
)"
then
  dm_tools__log_success "$title"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi
