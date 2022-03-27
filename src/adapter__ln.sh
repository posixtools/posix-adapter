#!/bin/sh
#==============================================================================
#   _
#  | |_ __
#  | | '_ \
#  | | | | |
#  |_|_| |_|
#
#==============================================================================
# TOOL: LN
#==============================================================================

#==============================================================================
#
#  posix_adapter__ln
#    [--symbolic]
#    [--verbose]
#    --target <target_path>
#    --link-name <link_name>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'ln' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --symbolic - Optional flag that should make the created link symbolic.
#   --symbolic - Optional flag that makes the execution verbose.
#   --target <target_path> - Mandatory target path option.
#   --link-name <link_name> - Mandatory link name option.
# Arguments:
#   None
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Verbose output.
# STDERR:
#   Mapped command's error output. Mapping error output.
# Status:
#   0  - Call was successful.
#   .. - Call failed with it's error status
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__ln() {
  posix_adapter__flag__symbolic='0'
  posix_adapter__flag__verbose='0'

  posix_adapter__flag__target='0'
  posix_adapter__value__target=''

  posix_adapter__flag__link_name='0'
  posix_adapter__value__link_name=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --symbolic)
        posix_adapter__flag__symbolic='1'
        shift
        ;;
      --verbose)
        posix_adapter__flag__verbose='1'
        shift
        ;;
      --target)
        posix_adapter__flag__target='1'
        posix_adapter__value__target="$2"
        shift
        shift
        ;;
      --link-name)
        posix_adapter__flag__link_name='1'
        posix_adapter__value__link_name="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__ln' \
          "Unexpected option '${1}'!" \
          'Only --symbolic --verbose --target and --link-name are available.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__ln' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__ln' \
          'Unexpected parameter!' \
          'This function does not take positional arguments.'
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
  # 0000
  posix_adapter__decision="${posix_adapter__flag__symbolic}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__verbose}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__target}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__link_name}"

  _posix_adapter__ln__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__target" \
    "$posix_adapter__value__link_name"
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
#   [2] value__target_path -  Target path passed to the command.
#   [3] value__link_name -  Link name passed to the command.
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
_posix_adapter__ln__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__target_path="$2"
  posix_adapter__value__link_name="$3"

  case "$posix_adapter__decision_string" in
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    0011)
      ln \
        \
        \
        "$posix_adapter__value__target_path" \
        "$posix_adapter__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    0111)
      ln \
        \
        -v \
        "$posix_adapter__value__target_path" \
        "$posix_adapter__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    1011)
      ln \
        -s \
        \
        "$posix_adapter__value__target_path" \
        "$posix_adapter__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    1111)
      ln \
        -s \
        -v \
        "$posix_adapter__value__target_path" \
        "$posix_adapter__value__link_name" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__ln' \
        'Unexpected parameter combination!' \
        'Only --symbolic --verbose are optional -target and --link_name are mandatory.'
      ;;
  esac
}
