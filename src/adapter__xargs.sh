#!/bin/sh
#==============================================================================
#
# __  ____ _ _ __ __ _ ___
# \ \/ / _` | '__/ _` / __|
#  >  < (_| | | | (_| \__ \
# /_/\_\__,_|_|  \__, |___/
#================|___/=========================================================
# TOOL: XARGS
#==============================================================================

#==============================================================================
#
#  posix_adapter__xargs
#    [--null]
#    [--replace <replace_string>]
#    [--max-args <arg_count>]
#    [..]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'xargs' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --null - xargs compatible -0 flag.
#   --replace <replace_string> - xargs compatible -I flag.
#   --max-args - xargs compatible -n flag.
# Arguments:
#   None
# STDIN:
#   Standard input for the command.
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
posix_adapter__xargs() {
  posix_adapter__flag__null='0'

  posix_adapter__flag__replace='0'
  posix_adapter__value__replace='0'

  posix_adapter__flag__max_args='0'
  posix_adapter__value__max_args='0'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --null)
        posix_adapter__flag__null='1'
        shift
        ;;
      --replace)
        posix_adapter__flag__replace='1'
        posix_adapter__value__replace="$2"
        shift
        shift
        ;;
      --max-args)
        posix_adapter__flag__max_args='1'
        posix_adapter__value__max_args="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__xargs' \
          "Unexpected option '${1}'!" \
          'You can only use --null --replace --max-args.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__xargs' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        # We are breaking here to have all the additional parameters available
        # in the '@' variable.
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # ,------ null
  # |,----- replace
  # ||,---- max_args
  # 000
  posix_adapter__decision="${posix_adapter__flag__null}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__replace}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__max_args}"

  _posix_adapter__xargs__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__replace" \
    "$posix_adapter__value__max_args" \
    "$@"
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
#   [2] value_replace - Value for the replace option.
#   [3] value_max_args - Value for the max args option.
#   [..] additionals - Additional variables.
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
_posix_adapter__xargs__common() {
  posix_adapter__decision_string="$1"
  shift
  posix_adapter__value__replace="$1"
  shift
  posix_adapter__value__max_args="$1"
  shift

  case "$posix_adapter__decision_string" in
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    000)
      xargs \
        \
        \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    001)
      xargs \
        \
        \
        -n "$posix_adapter__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    010)
      xargs \
        \
        -I "$posix_adapter__value__replace" \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    011)
      xargs \
        \
        -I "$posix_adapter__value__replace" \
        -n "$posix_adapter__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    100)
      xargs \
        -0 \
        \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    101)
      xargs \
        -0 \
        \
        -n "$posix_adapter__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    110)
      xargs \
        -0 \
        -I "$posix_adapter__value__replace" \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    111)
      xargs \
        -0 \
        -I "$posix_adapter__value__replace" \
        -n "$posix_adapter__value__max_args" \
        "$@" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__xargs' \
        'Unexpected parameter combination!' \
        'You can only use --null --replace --max-args.'
      ;;
  esac
}
