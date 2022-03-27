#!/bin/sh
#==============================================================================
#
# __      _____
# \ \ /\ / / __|
#  \ V  V / (__
#   \_/\_/ \___|
#==============================================================================
# TOOL: WC
#==============================================================================

#==============================================================================
#
#  posix_adapter__wc [--chars] [--lines] [--words] [<path>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'wc' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --chars - Use the wc compatible -c flag.
#   --lines - Use the wc compatible -l flag.
#   --words - Use the wc compatible -w flag.
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
posix_adapter__wc() {
  posix_adapter__flag__chars='0'
  posix_adapter__flag__lines='0'
  posix_adapter__flag__words='0'

  posix_adapter__flag__path='0'
  posix_adapter__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --chars)
        posix_adapter__flag__chars='1'
        shift
        ;;
      --lines)
        posix_adapter__flag__lines='1'
        shift
        ;;
      --words)
        posix_adapter__flag__words='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__wc' \
          "Unexpected option '${1}'!" \
          'You can only use --chars, --lines or --words.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__wc' \
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
            'posix_adapter__wc' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
  # 0000
  posix_adapter__decision="${posix_adapter__flag__chars}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__lines}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__words}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__path}"

  case "$POSIX_ADAPTER__RUNTIME__OS" in

    "$POSIX_ADAPTER__CONSTANT__OS__LINUX")
      _posix_adapter__wc__common \
        "$posix_adapter__decision" \
        "$posix_adapter__value__path"
      ;;

    "$POSIX_ADAPTER__CONSTANT__OS__MACOS")
      # This if else construction is needed because POSIX does not have the
      # pipefail feature.
      if posix_adapter__result="$( \
        _posix_adapter__wc__common \
          "$posix_adapter__decision" \
          "$posix_adapter__value__path" \
      )"
      then
        # Some old BSD based wc implementations pads these results with empty
        # spaces, hence the additional xargs call.
        echo "$posix_adapter__result" | xargs
      else
        posix_adapter__status="$?"
        exit "$posix_adapter__status"
      fi
      ;;

    *)
      posix_adapter__report_incompatible_call 'posix_adapter__wc'
      ;;
  esac
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
_posix_adapter__wc__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__path="$2"

  case "$posix_adapter__decision_string" in
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0000)
      wc \
        \
        \
        \
        \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0001)
      wc \
        \
        \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0010)
      wc \
        \
        \
        -w \
        \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0011)
      wc \
        \
        \
        -w \
        "$posix_adapter__value__path" \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0100)
      wc \
        \
        -l \
        \
        \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    0101)
      wc \
        \
        -l \
        \
        "$posix_adapter__value__path" \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    1000)
      wc \
        -c \
        \
        \
        \

      ;;
  # ,----- chars
  # |,---- lines
  # ||,--- words
  # |||,-- path
    1001)
      wc \
        -c \
        \
        \
        "$posix_adapter__value__path" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__wc' \
        'Unexpected parameter combination!' \
        'You can only have either --chars, --lines or --words'
      ;;
  esac
}
