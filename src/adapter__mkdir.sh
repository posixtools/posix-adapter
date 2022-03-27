#!/bin/sh
#==============================================================================
#             _       _ _
#   _ __ ___ | | ____| (_)_ __
#  | '_ ` _ \| |/ / _` | | '__|
#  | | | | | |   < (_| | | |
#  |_| |_| |_|_|\_\__,_|_|_|
#==============================================================================
# TOOL: MKDIR
#==============================================================================

#==============================================================================
#
#  posix_adapter__mkdir [--parents] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'mkdir' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --parents - mkdir compatible alias for the -p flag.
# Arguments:
#   [1] path - Path that should be created.
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
posix_adapter__mkdir() {
  posix_adapter__flag__parents='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --parents)
        posix_adapter__flag__parents='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__mkdir' \
          "Unexpected option '${1}'!" \
          'You can only use --parents.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__mkdir' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$posix_adapter__flag__path" -eq '0' ]
        then
          posix_adapter__flag__path='1'
          posix_adapter__value__path="$1"
          shift
        else
          posix_adapter__report_invalid_parameters \
            'posix_adapter__mkdir' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__path" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__mkdir' \
      'Missing <path> argument!' \
      'A directory can only be createdif you pass a path for it.'
  fi

  # Assembling the decision string.
  # ,-- parents
  # 0
  posix_adapter__decision="${posix_adapter__flag__parents}"

  _posix_adapter__mkdir__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__path"
}

#==============================================================================
# Common call mapping function
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_path - Path for the mkdir command.
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
_posix_adapter__mkdir__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,-- parents
    0)
      mkdir \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,-- parents
    1)
      mkdir \
        -p \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__mkdir' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
