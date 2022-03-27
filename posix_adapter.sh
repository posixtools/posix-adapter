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

# shellcheck source=./src/adapter__basename.sh
. "${posix_adapter__path_prefix}/src/adapter__basename.sh"
# shellcheck source=./src/adapter__cat.sh
. "${posix_adapter__path_prefix}/src/adapter__cat.sh"
# shellcheck source=./src/adapter__cut.sh
. "${posix_adapter__path_prefix}/src/adapter__cut.sh"
# shellcheck source=./src/adapter__date.sh
. "${posix_adapter__path_prefix}/src/adapter__date.sh"
# shellcheck source=./src/adapter__dirname.sh
. "${posix_adapter__path_prefix}/src/adapter__dirname.sh"
# shellcheck source=./src/adapter__echo.sh
. "${posix_adapter__path_prefix}/src/adapter__echo.sh"
# shellcheck source=./src/adapter__find.sh
. "${posix_adapter__path_prefix}/src/adapter__find.sh"
# shellcheck source=./src/adapter__fold.sh
. "${posix_adapter__path_prefix}/src/adapter__fold.sh"
# shellcheck source=./src/adapter__grep.sh
. "${posix_adapter__path_prefix}/src/adapter__grep.sh"
# shellcheck source=./src/adapter__ln.sh
. "${posix_adapter__path_prefix}/src/adapter__ln.sh"
# shellcheck source=./src/adapter__ls.sh
. "${posix_adapter__path_prefix}/src/adapter__ls.sh"
# shellcheck source=./src/adapter__mkdir.sh
. "${posix_adapter__path_prefix}/src/adapter__mkdir.sh"
# shellcheck source=./src/adapter__mkfifo.sh
. "${posix_adapter__path_prefix}/src/adapter__mkfifo.sh"
# shellcheck source=./src/adapter__mktemp.sh
. "${posix_adapter__path_prefix}/src/adapter__mktemp.sh"
# shellcheck source=./src/adapter__printf.sh
. "${posix_adapter__path_prefix}/src/adapter__printf.sh"
# shellcheck source=./src/adapter__readlink.sh
. "${posix_adapter__path_prefix}/src/adapter__readlink.sh"
# shellcheck source=./src/adapter__realpath.sh
. "${posix_adapter__path_prefix}/src/adapter__realpath.sh"
# shellcheck source=./src/adapter__rm.sh
. "${posix_adapter__path_prefix}/src/adapter__rm.sh"
# shellcheck source=./src/adapter__sed.sh
. "${posix_adapter__path_prefix}/src/adapter__sed.sh"
# shellcheck source=./src/adapter__sort.sh
. "${posix_adapter__path_prefix}/src/adapter__sort.sh"
# shellcheck source=./src/adapter__touch.sh
. "${posix_adapter__path_prefix}/src/adapter__touch.sh"
# shellcheck source=./src/adapter__tput.sh
. "${posix_adapter__path_prefix}/src/adapter__tput.sh"
# shellcheck source=./src/adapter__tr.sh
. "${posix_adapter__path_prefix}/src/adapter__tr.sh"
# shellcheck source=./src/adapter__uname.sh
. "${posix_adapter__path_prefix}/src/adapter__uname.sh"
# shellcheck source=./src/adapter__wc.sh
. "${posix_adapter__path_prefix}/src/adapter__wc.sh"
# shellcheck source=./src/adapter__xargs.sh
. "${posix_adapter__path_prefix}/src/adapter__xargs.sh"
# shellcheck source=./src/adapter__xxd.sh
. "${posix_adapter__path_prefix}/src/adapter__xxd.sh"


#==============================================================================
# SETTING THE ENVIRONMENT VARIABLES
#==============================================================================

#==============================================================================
# Execution mapping function for the 'basename' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS
# Options:
#   None
# Arguments:
#   [1] reported_from - Tool name where the error happened.
#   [2] reason - Short summary of the error.
#   [3] details - Detailed description of the error.
# STDIN:
#   Input passed to the mapped command.
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   None
# STDERR:
#   Compiled error message.
# Status:
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#==============================================================================
posix_adapter__report_invalid_parameters() {
  posix_adapter__reported_from="$1"
  posix_adapter__reason="$2"
  posix_adapter__details="$3"

  >&2 printf '%s' "ERROR | ${posix_adapter__reported_from} | reason     | "
  >&2 printf '%s\n' "${posix_adapter__reason}"
  >&2 printf '%s' "ERROR | ${posix_adapter__reported_from} | details    | "
  >&2 printf '%s\n' "${posix_adapter__details}"

  _posix_adapter__error_suggestion "$posix_adapter__reported_from"

  exit "$POSIX_ADAPTER__STATUS__INVALID_PARAMETERS"
}

#==============================================================================
# Execution mapping function for the 'basename' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL
# Options:
#   None
# Arguments:
#   [1] reported_from - Tool name where the error happened.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   None
# STDERR:
#   Compiled error message.
# Status:
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - Invalid parameter configuration.
#==============================================================================
posix_adapter__report_incompatible_call() {
  posix_adapter__reported_from="$1"

  >&2 printf '%s' "ERROR | ${posix_adapter__reported_from} | reason     |"
  >&2 printf '%s\n' 'No compatible call style was found! Giving up..'

  _posix_adapter__error_suggestion "$posix_adapter__reported_from"

  exit "$POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL"
}

#==============================================================================
# Common error reporting suggestion function that prints out a suggestion to
# the standard error output.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] reported_from - Tool name where the error happened.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   None
# STDERR:
#   Suggestion about the error.
# Status:
#   0 - Other status is not expected.
#==============================================================================
_posix_adapter__error_suggestion() {
  posix_adapter__reported_from="$1"

  >&2 printf '%s' "ERROR | ${posix_adapter__reported_from} | suggestion | "
  >&2 printf '%s' 'Probably a new use case needs to be added to the '
  >&2 printf '%s\n' "'${posix_adapter__reported_from}' function."
}

#==============================================================================
# GLOBAL VARIABLES
#==============================================================================

POSIX_ADAPTER__CONSTANT__OS__LINUX="Linux"
POSIX_ADAPTER__CONSTANT__OS__MACOS="Darwin"

POSIX_ADAPTER__STATUS__INVALID_PARAMETERS='98'
POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL='99'

# This variable is used by almost every tool mapping function internally. It
# was aquired with the non-mapped style to be able to use it in the mapped
# version of uname too. The -s flag should be supported in every release.
# shellcheck disable=SC2034
POSIX_ADAPTER__RUNTIME__OS="$(uname -s)"

# This file will be sourced to the user code-base so exporting the variable is
# not necessary here.
# shellcheck disable=SC2034
POSIX_ADAPTER__READY='1'
