#!/bin/sh
#==============================================================================
#       _            _              _           _
#      | |          | |            | |         | |
#    __| |_ __ ___  | |_ ___   ___ | |___   ___| |__
#   / _` | '_ ` _ \ | __/ _ \ / _ \| / __| / __| '_ \
#  | (_| | | | | | || || (_) | (_) | \__ \_\__ \ | | |
#   \__,_|_| |_| |_(_)__\___/ \___/|_|___(_)___/_| |_|
#
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
#------------------------------------------------------------------------------
# Tools:
#   echo sed
#==============================================================================
dm_tools__report_error_and_exit() {
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
# For better readability dm.test.sh is composed of smaller scripts that are
# sourced into it dynamically. As dm.test.sh is imported to the user codebase
# by sourcing, the conventional path determination cannot be used. The '$0'
# variable contains the the host script's path dm.test.sh is sourced from. The
# relative path to the root of the dm-test-runner subrepo has to be defined
# explicitly to the internal sourcing could be executed.
#==============================================================================

if [ -z ${DM_TOOLS__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX+x} ]
then
  dm_tools__report_error_and_exit \
    'Initialization failed!' \
    'Mandatory path prefix variable is missing!' \
    'DM_TOOLS__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX'
fi

dm_tools__path_prefix="${DM_TOOLS__CONFIG__MANDATORY__SUBMODULE_PATH_PREFIX}"

# shellcheck source=./src/tool__basename.sh
. "${dm_tools__path_prefix}/src/tool__basename.sh"
# shellcheck source=./src/tool__cat.sh
. "${dm_tools__path_prefix}/src/tool__cat.sh"
# shellcheck source=./src/tool__cut.sh
. "${dm_tools__path_prefix}/src/tool__cut.sh"
# shellcheck source=./src/tool__date.sh
. "${dm_tools__path_prefix}/src/tool__date.sh"
# shellcheck source=./src/tool__dirname.sh
. "${dm_tools__path_prefix}/src/tool__dirname.sh"
# shellcheck source=./src/tool__echo.sh
. "${dm_tools__path_prefix}/src/tool__echo.sh"
# shellcheck source=./src/tool__find.sh
. "${dm_tools__path_prefix}/src/tool__find.sh"
# shellcheck source=./src/tool__grep.sh
. "${dm_tools__path_prefix}/src/tool__grep.sh"
# shellcheck source=./src/tool__mkdir.sh
. "${dm_tools__path_prefix}/src/tool__mkdir.sh"
# shellcheck source=./src/tool__mkfifo.sh
. "${dm_tools__path_prefix}/src/tool__mkfifo.sh"
# shellcheck source=./src/tool__mktemp.sh
. "${dm_tools__path_prefix}/src/tool__mktemp.sh"
# shellcheck source=./src/tool__printf.sh
. "${dm_tools__path_prefix}/src/tool__printf.sh"
# shellcheck source=./src/tool__readlink.sh
. "${dm_tools__path_prefix}/src/tool__readlink.sh"
# shellcheck source=./src/tool__realpath.sh
. "${dm_tools__path_prefix}/src/tool__realpath.sh"
# shellcheck source=./src/tool__rm.sh
. "${dm_tools__path_prefix}/src/tool__rm.sh"
# shellcheck source=./src/tool__sed.sh
. "${dm_tools__path_prefix}/src/tool__sed.sh"
# shellcheck source=./src/tool__sort.sh
. "${dm_tools__path_prefix}/src/tool__sort.sh"
# shellcheck source=./src/tool__touch.sh
. "${dm_tools__path_prefix}/src/tool__touch.sh"
# shellcheck source=./src/tool__tput.sh
. "${dm_tools__path_prefix}/src/tool__tput.sh"
# shellcheck source=./src/tool__tr.sh
. "${dm_tools__path_prefix}/src/tool__tr.sh"
# shellcheck source=./src/tool__uname.sh
. "${dm_tools__path_prefix}/src/tool__uname.sh"
# shellcheck source=./src/tool__wc.sh
. "${dm_tools__path_prefix}/src/tool__wc.sh"
# shellcheck source=./src/tool__xargs.sh
. "${dm_tools__path_prefix}/src/tool__xargs.sh"
# shellcheck source=./src/tool__xxd.sh
. "${dm_tools__path_prefix}/src/tool__xxd.sh"


#==============================================================================
# SETTING THE READY VARIABLE
#==============================================================================

# This file will be sourced to the user code-base so exporting the variable is
# not necessary here.
# shellcheck disable=SC2034
DM_TOOLS__READY='1'
