#!/bin/sh
#==============================================================================
#      _ _
#   __| (_)_ __ _ __   __ _ _ __ ___   ___
#  / _` | | '__| '_ \ / _` | '_ ` _ \ / _ \
# | (_| | | |  | | | | (_| | | | | | |  __/
#  \__,_|_|_|  |_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: DIRNAME
#==============================================================================

#==============================================================================
#
#  dm_tools__dirname <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'dirname' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] path - Path from which the directory name should be separated.
# STDIN:
#   Standard input can be used to pass a path.
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__dirname() {
  if [ "$#" -eq 0 ]
  then
    # dirname does not support the standard input by it's own, so helping it
    # out with xargs..
    xargs dirname
  else
    if [ "$#" -gt 1 ]
    then
      dm_tools__report_invalid_parameters \
        'dm_tools__dirname' \
        'Unexpected parameter count!' \
        "Only 1 parameter is expected, got ${#}!"
    fi

    case "$1" in
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__dirname' \
          "Unexpected option '${1}'!" \
          'This function does not take options.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__dirname' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
    esac

    dirname "$1"
  fi
}
