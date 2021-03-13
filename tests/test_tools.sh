#!/bin/sh

#==============================================================================
# This testing file is intended to test the dependent program and shell
# built-ins to have the required behavior. If a tool fails during these test,
# an additional tool selection layer needs to be introduced to the system that
# dynamically selects the appropriate tool interface to be used.
#==============================================================================

#==============================================================================
# SANE ENVIRONMENT
#==============================================================================

set -e  # exit on error
set -u  # prevent unset variable expansion

#==============================================================================
# PATH CHANGE
#==============================================================================

# This is the only part where the code has to be prepared for the missing tool
# capabilities. It is known that on MacOS readlink does not support the -f flag
# by default. https://stackoverflow.com/a/4031502/1565331
if target_path="$(readlink -f "$0" 2>/dev/null)"
then
  cd "$(dirname "$target_path")"
else
  # If the path cannot be determined with readlink, we have to check if this
  # script is executed through a symlink or not.
  if [ -L "$0" ]
  then
    # If the current script is executed through a symlink, we are aout of luck,
    # because without readlink, there is no universal solution for this problem
    # that uses the default shell toolset.
    echo "Symlinked script won't work on this machine.."
    echo "Make sure you install a readlink version that supports the -f flag."
  else
    # If the current script is not executed through a symlink, we can determine
    # the path with dirname.
    cd "$(dirname "$0")"
  fi
fi

#==============================================================================
# DM TOOLS INTEGRATION
#==============================================================================

. ../dm.tools.sh

# IMPORTANT: After this, every non shell built-in command should be called
# through the provided dm_tools API to ensure the compatibility on different
# environments.

#==============================================================================
# PRETTY PRINTING
#==============================================================================

# Checking the availibility and usability of tput. If it is available and
# usable we can set the global coloring variables with it by expecting a
# possibly missing color/modifier.
if command -v tput >/dev/null && tput init >/dev/null 2>&1
then
  if ! RED="$(dm_tools__tput setaf 1)"
  then
    RED=''
  fi
  if ! GREEN="$(dm_tools__tput setaf 2)"
  then
    GREEN=''
  fi
  if ! BLUE="$(dm_tools__tput setaf 4)"
  then
    BLUE=''
  fi
  if ! RESET="$(dm_tools__tput sgr0)"
  then
    RESET=''
  fi
  if ! BOLD="$(dm_tools__tput bold)"
  then
    BOLD=''
  fi
else
  RED=''
  GREEN=''
  BLUE=''
  RESET=''
  BOLD=''
fi

log_task() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${BLUE}..${RESET}${BOLD} ]${RESET} ${message}"
}

log_success() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${GREEN}OK${RESET}${BOLD} ]${RESET} ${message}"
}

log_failure() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${RED}!!${RESET}${BOLD} ]${RESET} ${message}"
}

tool_assert() {
  title="$1"
  expected="$2"
  result="$3"

  if [ "$result" = "$expected"  ]
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure "expected: '${expected}'"
    log_failure "result:   '${result}'"
    exit 1
  fi
}

tool_failure() {
  title="$1"
  status="$2"
  log_failure "$title"
  log_failure "failed with status ${status}, possible unsupported parameter"
  exit 1
}

log_task 'Running test suite..'
echo ''

#==============================================================================
# TOOL: BASENAME
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: CAT
#==============================================================================
# No flags were used with this tool only the dash file parameter that should
# explicitly trigger the standard input read, assuming the this behavior is
# always present.

#==============================================================================
# TOOL: CD
#==============================================================================
# Assuming this utility behaves uniformily as it is defined by the POSIX
# standard.

#==============================================================================
# TOOL: COMMAND
#==============================================================================
# Assuming this utility behaves uniformily as it is defined by the POSIX
# standard.

#==============================================================================
# TOOL: CUT
#==============================================================================
title='cut :: delimiter and field selection'
data='one/two/three/four'
expected='two/three/four'
if result="$(dm_tools__echo "$data" | dm_tools__cut --delimiter '/' --fields '2-')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='cut :: character range selection'
data='123456789'
expected='12345'
if result="$(dm_tools__echo "$data" | dm_tools__cut --characters '1-5')"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
# TOOL: DATE
#==============================================================================
title='date :: generated timestamp is numbers only'
if result="$(dm_tools__date +'%s%N')"
then
  if dm_tools__echo "$result" | dm_tools__grep --silent -E '[[:digit:]]+'
  then
    log_success "$title"
  else
    log_failure "$title"
    log_failure 'should have generated only digits'
    log_failure "failed result: '${result}'"
    exit 1
  fi
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
# TOOL: DIRNAME
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: ECHO
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: EXIT
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: FIND
#==============================================================================
title='find :: basic file search by name'
if dm_tools__find . -type 'f' -name '*' >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='find :: basic file search by name zero terminated'
if dm_tools__find . -type 'f' -name '*' -print0 >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='find :: basic direcroty search by name'
if dm_tools__find . -type 'd' -name '*' >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

title='find :: basic directory search by name zero terminated'
if dm_tools__find . -type 'd' -name '*' -print0 >/dev/null
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

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

#==============================================================================
# TOOL: MKDIR
#==============================================================================
title='mkdir :: parents flag'
if dm_tools__mkdir --parents ../tests
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
# TOOL: MKFIFO
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: MKTEMP
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

#==============================================================================
# TOOL: PRINTF
#==============================================================================
title='printf :: minimum width specifier'
expected=' 42'
if result="$(dm_tools__printf '%*s' 3 '42')"
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

title='printf :: precision specifier'
expected='123'
if result="$(dm_tools__printf '%.*s' 3 '123456')"
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

title='printf :: combined minimum width and precision specifier'
expected=' 123'
if result="$(dm_tools__printf '%*.*s' 4 3 '123456')"
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

#==============================================================================
# TOOL: READ
#==============================================================================
# The read built-in is specified under the POSIX standard, the used -r flag
# should be supported on all platforms.

#==============================================================================
# TOOL: READLINK
#==============================================================================
title='readlink :: canonicalize mode'
if dm_tools__readlink -f . >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
# TOOL: REALPATH
#==============================================================================
title='realpath :: no symlink mode'
if dm_tools__realpath --no-symlink . >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

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

#==============================================================================
# TOOL: SORT
#==============================================================================
title='sort :: parameter checking'
if dm_tools__echo 'hello' | dm_tools__sort --zero-terminated --dictionary-order >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
# TOOL: TEST
#==============================================================================
# The test built-in is specified under the POSIX standard, the used -r flag
# should be supported on all platforms.

#==============================================================================
# TOOL: TOUCH
#==============================================================================
# No flags were used with this tool, assuming the base behavior is always
# present.

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

#==============================================================================
# TOOL: UNAME
#==============================================================================
title='uname :: parameter checking'
# if dm_tools__uname -s -r -m >/dev/null 2>&1
if dm_tools__uname --kernel-name --kernel-release --machine >/dev/null 2>&1
then
  log_success "$title"
else
  status="$?"
  tool_failure "$title" "$status"
fi

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

#==============================================================================

echo ''
log_success 'Test suite finished'
