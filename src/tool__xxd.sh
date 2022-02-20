#!/bin/sh
#==============================================================================
#                _
# __  ____  ____| |
# \ \/ /\ \/ / _` |
#  >  <  >  < (_| |
# /_/\_\/_/\_\__,_|
#==============================================================================
# TOOL: XXD
#==============================================================================

#==============================================================================
#
#  dm_tools__xxd [--plain] [--revert]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'xxd' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --plain - xxd compatible plain hexdump flag -p.
#   --revert - xxd compatible revert flag -r.
# Arguments:
#   None
# STDIN:
#   Value is read from the standard input.
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
dm_tools__xxd() {
  dm_tools__flag__plain='0'
  dm_tools__flag__revert='0'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --plain)
        dm_tools__flag__plain='1'
        shift
        ;;
      --revert)
        dm_tools__flag__revert='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__xxd' \
          "Unexpected option '${1}'!" \
          'You can only use --plain --revert.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__xxd' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__xxd' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,------ plain
  # |,----- revert
  # 00
  dm_tools__decision="${dm_tools__flag__plain}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__revert}"

  _dm_tools__xxd__common \
    "$dm_tools__decision"
}

#==============================================================================
# Common call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
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
#   0  - Call succeeded.
#   .. - Call failed with it's error status
#==============================================================================
_dm_tools__xxd__common() {
  dm_tools__decision_string="$1"

  case "$dm_tools__decision_string" in
  # ,------ plain
  # |,----- revert
    00)
      dm_tools__report_invalid_parameters \
        'dm_tools__xxd' \
        'Unexpected parameter combination!' \
        'You can only use --plain [--revert].'
      ;;
  # ,------ plain
  # |,----- revert
    01)
      dm_tools__report_invalid_parameters \
        'dm_tools__xxd' \
        'Unexpected parameter combination!' \
        'You can only use --plain [--revert].'
      ;;
  # ,------ plain
  # |,----- revert
    10)
      if command -v xxd >/dev/null
      then
        xxd -p
      else
        # Since xxd is not a common tool and for linux it is mostly shipped
        # with vim, we are replacing its functionality with python as a last
        # resort.
        python -c 'import sys;print("".join([line.encode().hex() for line in sys.stdin]))'
      fi
      ;;
  # ,------ plain
  # |,----- revert
    11)
      if command -v xxd >/dev/null
      then
        xxd -p -r
      else
        # See the explanation one case up for the usage of python.
        python -c 'import sys;print("".join([bytearray.fromhex(line).decode() for line in sys.stdin]).rstrip())'
      fi
      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__xxd' \
        'Unexpected parameter combination!' \
        'You can only use --plain [--revert].'
      ;;
  esac
}
