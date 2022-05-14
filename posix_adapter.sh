#!/bin/sh
#==============================================================================
#                  _                   _             _                _
#  _ __   ___  ___(_)_  __    __ _  __| | __ _ _ __ | |_ ___ _ __ ___| |__
# | '_ \ / _ \/ __| \ \/ /   / _` |/ _` |/ _` | '_ \| __/ _ \ '__/ __| '_ \
# | |_) | (_) \__ \ |>  <   | (_| | (_| | (_| | |_) | ||  __/ | _\__ \ | | |
# | .__/ \___/|___/_/_/\_\___\__,_|\__,_|\__,_| .__/ \__\___|_|(_)___/_| |_|
# |_|                   |_____|               |_|
#==============================================================================

#==============================================================================
# SANE ENVIRONMENT
#==============================================================================

set -e  # exit on error
set -u  # prevent unset variable expansion

#==============================================================================
# MAIN ERROR HANDLING ASSERTION FUNCTION
#==============================================================================

#==============================================================================
# Error reporting function that will display the given message and abort the
# execution. This needs to be defined in the highest level to be able to use it
# without sourcing the sub files.
#------------------------------------------------------------------------------
# Globals:
#   RED
#   BOLD
#   RESET
# Arguments:
#   [1] message - Error message that will be displayed.
#   [2] details - Detailed error message.
#   [3] reason - Reason of this error.
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
#   1 - System will exit at the end of this function.
#==============================================================================
posix_adapter__report_error_and_exit() {
  ___message="$1"
  ___details="$2"
  ___reason="$3"

  # This function might be called before the global coloring valriables gets
  # initialized, hence the default value setting.
  RED="${RED:=}"
  BOLD="${BOLD:=}"
  RESET="${RESET:=}"

  >&2 printf '%s=======================================================' "$RED"
  >&2 echo "========================${RESET}"
  >&2 echo "  ${RED}${BOLD}FATAL ERROR${RESET}"
  >&2 printf '%s=======================================================' "$RED"
  >&2 echo "========================${RESET}"
  >&2 echo ''
  >&2 echo "  ${RED}${___message}${RESET}"
  >&2 echo "  ${RED}${___details}${RESET}"
  >&2 echo ''
  # Running in a subshell to keep line length below 80.
  # shellcheck disable=SC2005
  >&2 echo "$( \
    echo "${___reason}" | sed "s/^/  ${RED}/" | sed "s/$/${RESET}/" \
  )"
  >&2 echo ''
  >&2 printf '%s=======================================================' "$RED"
  >&2 echo "========================${RESET}"

  exit 1
}

#==============================================================================
# SOURCING SUBMODULES
#==============================================================================

#==============================================================================
# For better readability, posix_adapter.sh is composed  out of smaller scripts
# that are sourced into it dynamically. As posix_adapter.sh is imported to the
# user codebase by sourcing, the conventional path determination cannot be
# used. The '$0' variable contains the the host script's path posix_adapter.sh
# is sourced from. Hence, a global variable needs to be set by the calling code
# that contains the path prefix posix_adapter.sh is called from.
#==============================================================================

if [ -z ${POSIX_ADAPTER__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX+x} ]
then
  posix_adapter__report_error_and_exit \
    'Initialization failed!' \
    'Mandatory path prefix variable is missing!' \
    'POSIX_ADAPTER__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX'
fi

posix_adapter__path_prefix="${POSIX_ADAPTER__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX}"

#==============================================================================
# GLOBAL VARIABLES
#==============================================================================

PATH="${PATH}:${posix_adapter__path_prefix}/bin"

# These two status code variables will be used in the test cases.
# shellcheck disable=SC2034
POSIX_ADAPTER__STATUS__INVALID_PARAMETERS='98'
# shellcheck disable=SC2034
POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL='99'

# This file will be sourced to the user code-base so exporting the variable is
# not necessary here.
# shellcheck disable=SC2034
POSIX_ADAPTER__READY='1'

