#!/bin/sh
#==============================================================================
#                  _
#   ___  ___  _ __| |_
#  / __|/ _ \| '__| __|
#  \__ \ (_) | |  | |_
#  |___/\___/|_|   \__|
#==============================================================================
# TOOL: SORT
#==============================================================================

#==============================================================================
#
#  posix_adapter__sort [--zero-terminated] [--dictionary-order] [<path>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'sed' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --zero-terminated - Use the sort compatible -z flag.
#   --dictionary-order - Use the sort compatible -d flag.
# Arguments:
#   [1] [path] - Optional file path.
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
posix_adapter__sort() {
  posix_adapter__flag__zero_terminated='0'
  posix_adapter__flag__dictionary_order='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --zero-terminated)
        posix_adapter__flag__zero_terminated='1'
        shift
        ;;
      --dictionary-order)
        posix_adapter__flag__dictionary_order='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__sort' \
          "Unexpected option '${1}'!" \
          'You can only use --zero-terminated or --dictionary-order.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__sort' \
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
            'posix_adapter__sort' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
  # 000
  posix_adapter__decision="${posix_adapter__flag__zero_terminated}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__dictionary_order}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__path}"

  _posix_adapter__sort__common \
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
#   [2] value_path - Value for the positional path argument.
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
_posix_adapter__sort__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    000)
      sort \
        \
        \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    001)
      sort \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    010)
      sort \
        \
        --dictionary-order \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    011)
      sort \
        \
        --dictionary-order \
        "$posix_adapter__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    100)
      sort \
        --zero-terminated \
        \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    101)
      sort \
        --zero-terminated \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    110)
      sort \
        --zero-terminated \
        --dictionary-order \
        \

      ;;
  # ,----- zero_terminated
  # |,---- dictionary_order
  # ||,--- path
    111)
      sort \
        --zero-terminated \
        --dictionary-order \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__sort' \
        'Unexpected parameter combination!' \
        'Only --zero-terminated and --dictionary-order is available.'
      ;;
  esac
}
