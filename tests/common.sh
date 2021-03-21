#==============================================================================
# COLORS
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

#==============================================================================
# PRETTY PRINTING
#==============================================================================

dm_tools__log_task() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${BLUE}>>${RESET}${BOLD} ]${RESET} ${message}"
}

dm_tools__log_success() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${GREEN}OK${RESET}${BOLD} ]${RESET} ${message}"
}

dm_tools__log_failure() {
  message="$1"
    dm_tools__echo "${BOLD}[ ${RED}!!${RESET}${BOLD} ]${RESET} ${message}"
}

#==============================================================================
# ASSERTIONS
#==============================================================================

dm_tools__assert() {
  title="$1"
  expected="$2"
  result="$3"

  if [ "$result" = "$expected"  ]
  then
    dm_tools__log_success "$title"
  else
    dm_tools__log_failure "$title"
    dm_tools__log_failure "expected: '${expected}'"
    dm_tools__log_failure "result:   '${result}'"
    exit 1
  fi
}

dm_tools__failure() {
  title="$1"
  status="$2"
  dm_tools__log_failure "$title"
  dm_tools__log_failure "failed with status ${status}, possible unsupported parameter"
  exit 1
}
