#!/bin/sh
#==============================================================================
#   _               _
#  | |_ _ __  _   _| |_
#  | __| '_ \| | | | __|
#  | |_| |_) | |_| | |_
#   \__| .__/ \__,_|\__|
#======|_|=====================================================================
# TOOL: TPUT
#==============================================================================

#==============================================================================
#
#  posix_adapter__tput <tput_specification>..
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'tput' command line tool. This is the only
# command mapping besides printf that is only a proxy because of the nature of
# tput. It also performs a fail-safe step and supresses not supported escape
# sequences by returnin an empty string in case of error.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [..] specification - tput compatible specification.
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
#   0 - Other staus is not expected.
#==============================================================================
posix_adapter__tput() {
  if ! tput "$@" 2>/dev/null
  then
    printf '%s' ''
  fi
}

#==============================================================================
#
#  posix_adapter__tput__is_available
#
#------------------------------------------------------------------------------
# Function that should evaluate the availibility and usability of the tput
# utility.
#------------------------------------------------------------------------------
# Globals:
#   None
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
#   0 - tput is available.
#   1 - tput is not available.
#==============================================================================
posix_adapter__tput__is_available() {
  if command -v tput >/dev/null && tput init >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}
