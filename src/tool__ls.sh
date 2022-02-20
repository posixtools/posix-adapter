#!/bin/sh
#==============================================================================
#   _
#  | |___
#  | / __|
#  | \__ \
#  |_|___/
#==============================================================================
# TOOL: LS
#==============================================================================

#==============================================================================
#
#  dm_tools__ls [--all] [--almost-all] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'ls' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --all - ls compatible -a flag equivavelent.
#   --almost-all - ls compatible -A flag equivavelent.
# Arguments:
#   [1] path - Path that should be listed.
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__ls() {
  dm_tools__flag__all='0'
  dm_tools__flag__almost_all='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --all)
        dm_tools__flag__all='1'
        shift
        ;;
      --almost-all)
        dm_tools__flag__almost_all='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__ls' \
          "Unexpected option '${1}'!" \
          'You can only use --all or --almost-all.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__ls' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__path" -eq '0' ]
        then
          dm_tools__flag__path='1'
          dm_tools__value__path="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__ls' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__path" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__ls' \
      'Missing <path> argument!' \
      'To be able to use readlink, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,-- all
  # |,- almost_all
  # 00
  dm_tools__decision="${dm_tools__flag__all}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__almost_all}"

  _dm_tools__ls__common \
    "$dm_tools__decision" \
    "$dm_tools__value__path"
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
#   [2] value_path - Path value.
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
_dm_tools__ls__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,-- all
  # |,- almost_all
    00)
      ls \
        \
        \
        "$dm_tools__value__path" \

      ;;
  # ,-- all
  # |,- almost_all
    01)
      ls \
        \
        -A \
        "$dm_tools__value__path" \

      ;;
  # ,-- all
  # |,- almost_all
    10)
      ls \
        -a \
        \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__ls' \
        'Unexpected parameter combination!' \
        'You can only have --all or --almost-all.'
      ;;
  esac
}
