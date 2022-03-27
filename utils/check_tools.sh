#!/bin/sh
#==============================================================================
# Collect the external tool cadidates from the source code of the given path.
#------------------------------------------------------------------------------
# Globals:
#   None
# Arguments:
#   [1] path - path where the search should be started.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Search result.
# STDERR:
#   None
# Status:
#   0 - Other status is not expected.
#==============================================================================
path="$1"

echo '==============================================================================='
echo " Working in:  '$(pwd)'"
echo " Target_path: '${path}'"
echo '-------------------------------------------------------------------------------'
echo ' Looking for potential commands that are not covered with posix_adapter..'
echo '-------------------------------------------------------------------------------'

get_lines() {
  for line in $(find "$path" -type 'f' -name '*.sh' -exec grep -v '^#.*' {} \;)
  do
    printf '%s' "$line" | xargs -0 -n 1
  done
}

for candidate in $(get_lines | sort | uniq)
do
  if result="$(command -v "$candidate" 2>/dev/null)"
  then
    if echo "$result" | grep --silent "^/.*"
    then
      echo " ${candidate}"
    fi
  fi
done

echo '-------------------------------------------------------------------------------'
echo ' You should look through the source code and validate if a posix_adapter'
echo ' mapping is needed or not.'
echo '==============================================================================='
