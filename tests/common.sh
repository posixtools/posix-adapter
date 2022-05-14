#!/bin/sh
#==============================================================================
# COLORS
#==============================================================================

# Checking the availibility and usability of tput. If it is available and
# usable we can set the global coloring variables with it by expecting a
# possibly missing color/modifier.
if command -v tput >/dev/null && tput init >/dev/null 2>&1
then
  if ! RED="$(tput setaf 1)"
  then
    RED=''
  fi
  if ! GREEN="$(tput setaf 2)"
  then
    GREEN=''
  fi
  if ! BLUE="$(tput setaf 4)"
  then
    BLUE=''
  fi
  if ! RESET="$(tput sgr0)"
  then
    RESET=''
  fi
  if ! BOLD="$(tput bold)"
  then
    BOLD=''
  fi
  if ! DIM="$(tput dim)"
  then
    DIM=''
  fi
else
  RED=''
  GREEN=''
  BLUE=''
  RESET=''
  BOLD=''
  DIM=''
fi

#==============================================================================
# PRETTY PRINTING
#==============================================================================

posix_adapter__test__log_task() {
  ___log_message="$1"
  echo "${BOLD}[ ${BLUE}>>${RESET}${BOLD} ]${RESET} ${___log_message}"
}

posix_adapter__test__log_success() {
  ___log_message="$1"
  echo "${BOLD}[ ${GREEN}OK${RESET}${BOLD} ]${RESET} ${___log_message}"
}

posix_adapter__test__log_failure() {
  ___log_message="$1"
  echo "${BOLD}[ ${RED}!!${RESET}${BOLD} ]${RESET} ${___log_message}"
}

posix_adapter__test__valid_case() {
  ___title="$1"
  printf '%s' "[ ${BLUE}${DIM}SHOULD PASS${RESET} ] ${BOLD}${___title}${RESET}"
}

posix_adapter__test__error_case() {
  ___title="$1"
  printf '%s' "[ ${BLUE}${DIM}SHOULD FAIL${RESET} ] ${BOLD}${___title}${RESET}"
}

_posix_adapter__test__test_case_succeeded() {
  printf '%s\n' " - ${BOLD}${GREEN}ok${RESET}"
}

_posix_adapter__test__test_case_failed() {
  printf '%s\n' " - ${BOLD}${RED}not ok${RESET}"
}

posix_adapter__test__line() {
  printf '%s' "${DIM}"
  printf '%s' '-----------------------------------------------------------------'
  printf '%s' '-------------------'
  printf '%s\n' "${RESET}"
}

#==============================================================================
# ASSERTIONS
#==============================================================================

POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT='0'

#==============================================================================
# Assertion function that compares two values.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT
#   BOLD
#   RED
# Options:
#   None
# Arguments:
#   [1] expected - Expected value.
#   [2] result - Resulted value.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Assertion result.
# STDERR:
#   None
# Status:
#   0 - Assertion succeeded.
#   1 - Assertion failed.
#==============================================================================
posix_adapter__test__assert_equal() {
  ___expected="$1"
  ___result="$2"

  if [ "$___result" = "$___expected" ]
  then
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_succeeded
    fi

  else
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_failed
    fi

    printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
    printf '%s' "posix_adapter__test__assert_equal - "
    printf '%s\n' "${BOLD}Assertion failed!${RESET}"

    printf '  %s' "${RED}expected: "
    printf '%s\n' "'${BOLD}${___expected}${RESET}${RED}'${RESET}"

    printf '  %s' "${RED}result:   "
    printf '%s\n' "'${BOLD}${___result}${RESET}${RED}'${RESET}"

    exit 1
  fi
}

#==============================================================================
#
#  posix_adapter__test__assert_invalid_parameters <status> <error_message>
#
#------------------------------------------------------------------------------
# Assertion function that checks if the status is the expected invalid
# parameters status code. If it is, it prints out the captured error message
# provided by the tool. If the status code doesn't match, it prints out an
# error message, then terminates the testing process.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS
#   POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT
#   DIM
#   BOLD
#   RED
#   RESET
# Options:
#   None
# Arguments:
#   [1] status - Resulted status that should be tested.
#   [2] error_message - Captured error message the tool outputted.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Captured error printout from the command in case of success, or error
#   message in case of failure.
# STDERR:
#   None
# Status:
#   0 - Assertion succeeded.
#   1 - Assertion failed.
#==============================================================================
posix_adapter__test__assert_invalid_parameters() {
  ___status="$1"
  ___error_message="$2"

  ___expected="$POSIX_ADAPTER__STATUS__INVALID_PARAMETERS"

  if [ "$___status" -eq "$___expected" ]
  then
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_succeeded
    fi
    printf '%s\n' "${DIM}${___error_message}${RESET}"

  else
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_failed
    fi

    printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
    printf '%s' "posix_adapter__test__assert_invalid_parameters - "
    printf '%s' "${RED}${BOLD}The tested tool should have reported an invalid "
    printf '%s\n' "parameters error.${RESET}"

    printf '  %s' "${RED}expected exit status: "
    printf '%s\n' "${BOLD}${___expected}${RESET}"

    printf '  %s' "${RED}resulted exit status: "
    printf '%s\n' "${BOLD}${___status}${RESET}"

    exit 1
  fi
}

#==============================================================================
#
#  posix_adapter__test__assert_incompatible_call <status> <error_message>
#
#------------------------------------------------------------------------------
# Assertion function that checks if the status is the expected incompatible
# call status code. If it is, it prints out the captured error message provided
# by the tool. If the status code doesn't match, it prints out an error
# message, then terminates the testing process.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL
#   POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT
#   DIM
#   BOLD
#   RED
#   RESET
# Options:
#   None
# Arguments:
#   [1] status - Resulted status that should be tested.
#   [2] error_message - Captured error message the tool outputted.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Captured error printout from the command in case of success, or error
#   message in case of failure.
# STDERR:
#   None
# Status:
#   0 - Assertion succeeded.
#   1 - Assertion failed.
#==============================================================================
posix_adapter__test__assert_incompatible_call() {
  ___status="$1"
  ___error_message="$2"

  ___expected="$POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL"

  if [ "$___status" -eq "$___expected" ]
  then
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_succeeded
    fi
    printf '%s\n' "${DIM}${___error_message}${RESET}"

  else
    if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _posix_adapter__test__test_case_failed
    fi

    printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
    printf '%s' "posix_adapter__test__assert_incompatible_call - "
    printf '%s' "${RED}${BOLD}The tested tool should have reported an incompatible "
    printf '%s\n' "call error.${RESET}"

    printf '  %s' "${RED}expected exit status: "
    printf '%s\n' "${BOLD}${___expected}${RESET}"

    printf '  %s' "${RED}resulted exit status: "
    printf '%s\n' "${BOLD}${___status}${RESET}"

    exit 1
  fi
}

#==============================================================================
#
# posix_adapter__test__test_case_failed <status>
#
#------------------------------------------------------------------------------
# Assertion function that should be called when a tested command returns an
# unexpected status code. This function will print out an error message then
# terminates the execution.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT
#   BOLD
#   RED
#   RESET
# Options:
#   None
# Arguments:
#   [1] status - Status of the failed tool call.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Error message.
# STDERR:
#   None
# Status:
#   1 - Test case failed.
#==============================================================================
posix_adapter__test__test_case_failed() {
  ___status="$1"

  if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
  then
    _posix_adapter__test__test_case_failed
  fi

  printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
  printf '%s' 'posix_adapter__test__test_case_failed - '
  printf '%s\n' "${BOLD}Unexpected status!${RESET}"

  printf '%s' "  ${RED}Failed with unexpected non zero status ${BOLD}"
  printf '%s' "${___status}${RESET}${RED}, possibly due to an unsupported "
  printf '%s\n' "call style.${RESET}"

  exit 1
}

#==============================================================================
#
# posix_adapter__test__test_case_passed
#
#------------------------------------------------------------------------------
# Marks the test case as passed.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT
# Options:
#   None
# Arguments:
#   None
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   None
# STDERR:
#   None
# Status:
#   1 - Test case failed.
#==============================================================================
posix_adapter__test__test_case_passed() {
  if [ "$POSIX_ADAPTER__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
  then
    _posix_adapter__test__test_case_succeeded
  fi
}
