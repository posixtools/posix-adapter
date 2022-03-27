#!/bin/sh
#==============================================================================
#
#   _ __ _ __ ___
#  | '__| '_ ` _ \
#  | |  | | | | | |
#  |_|  |_| |_| |_|
#==============================================================================
# TOOL: RM
#==============================================================================

#==============================================================================
#
#  posix_adapter__rm [--recursive] [--force] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'rm' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --recursive - rm compatible flag for the -r flag.
#   --force - rm compatible flag for the -f flag.
#   --verbose - rm compatible flag for the -v flag.
# Arguments:
#   [1] path - Path that should be removed.
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
posix_adapter__rm() {
  posix_adapter__flag__recursive='0'
  posix_adapter__flag__force='0'
  posix_adapter__flag__verbose='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --recursive)
        posix_adapter__flag__recursive='1'
        shift
        ;;
      --force)
        posix_adapter__flag__force='1'
        shift
        ;;
      --verbose)
        posix_adapter__flag__verbose='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__rm' \
          "Unexpected option '${1}'!" \
          'You can only use --recursive and --force.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__rm' \
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
            'posix_adapter__rm' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__path" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__rm' \
      'Missing <path> argument!' \
      'To be able to use rm, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
  posix_adapter__decision="${posix_adapter__flag__recursive}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__force}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__verbose}"

  _posix_adapter__rm__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__path"
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
_posix_adapter__rm__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    000)
      rm \
        \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    001)
      rm \
        \
        \
        -v \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    010)
      rm \
        \
        -f \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    011)
      rm \
        \
        -f \
        -v \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    100)
      rm \
        -r \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    101)
      rm \
        -r \
        \
        -v \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    110)
      rm \
        -r \
        -f \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,---- recursive
  # |,--- force
  # ||,-- verbose
  # 000
    111)
      rm \
        -r \
        -f \
        -v \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__rm' \
        'Unexpected parameter combination!' \
        'You can only have --recursive --force and --verbose.'
      ;;
  esac
}
