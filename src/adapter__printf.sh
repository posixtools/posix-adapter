#!/bin/sh
#==============================================================================
#              _       _    __
#   _ __  _ __(_)_ __ | |_ / _|
#  | '_ \| '__| | '_ \| __| |_
#  | |_) | |  | | | | | |_|  _|
#  | .__/|_|  |_|_| |_|\__|_|
#==|_|=========================================================================
# TOOL: PRINTF
#==============================================================================

#==============================================================================
#
#  posix_adapter__printf <printf_specification>..
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'printf' command line tool with a uniform
# interface. This is the only command mapping besides tput that is only a proxy
# because of the nature of printf.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [..] specification - printf compatible specification.
# STDIN:
#   Input passed to the mapped command.
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Mapped command's output.
# STDERR:
#   Mapped command's error output. Mapping error output.
# Status:
#   0  - Call was successful.
#   .. - Call failed with it's error status
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__printf() {
  # We are proxying all the parameters here, hence ignoring the warning.
  # shellcheck disable=SC2059
  printf "$@"
}

