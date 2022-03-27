#!/bin/sh
#==============================================================================
#
#  _   _ _ __   __ _ _ __ ___   ___
# | | | | '_ \ / _` | '_ ` _ \ / _ \
# | |_| | | | | (_| | | | | | |  __/
#  \__,_|_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: UNAME
#==============================================================================

#==============================================================================
#
#  posix_adapter__uname
#    [--kernel-name]
#    [--kernel-release]
#    [--machine]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'uname' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --kernel-name - uname compatible kernel name flag.
#   --kernel-release - uname compatible kernel release flag.
#   --machine - uname compatible machine flag.
# Arguments:
#   None
# STDIN:
#   None
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
posix_adapter__uname() {
  posix_adapter__flag__kernel_name='0'
  posix_adapter__flag__kernel_release='0'
  posix_adapter__flag__machine='0'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --kernel-name)
        posix_adapter__flag__kernel_name='1'
        shift
        ;;
      --kernel-release)
        posix_adapter__flag__kernel_release='1'
        shift
        ;;
      --machine)
        posix_adapter__flag__machine='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__uname' \
          "Unexpected option '${1}'!" \
          'You can only use --kernel-name --kernel-release and --machine.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__uname' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__uname' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
  # 000
  posix_adapter__decision="${posix_adapter__flag__kernel_name}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__kernel_release}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__machine}"

  _posix_adapter__uname__common \
    "$posix_adapter__decision"
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
_posix_adapter__uname__common() {
  posix_adapter__decision_string="$1"

  case "$posix_adapter__decision_string" in
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    000)
      uname \
        \
        \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    001)
      uname \
        \
        \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    010)
      uname \
        \
        -r \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    011)
      uname \
        \
        -r \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    100)
      uname \
        -s \
        \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    101)
      uname \
        -s \
        \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    111)
      uname \
        -s \
        -r \
        -m \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__uname' \
        'Unexpected parameter combination!' \
        'You can only have --kernel_name --kernel_release --machine.'
      ;;
  esac
}
