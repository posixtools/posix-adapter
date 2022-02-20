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
#  dm_tools__wc [--chars] [--lines] [--words] [<path>]
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__wc() {
  dm_tools__flag__chars='0'
  dm_tools__flag__lines='0'
  dm_tools__flag__words='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --chars)
        dm_tools__flag__chars='1'
        shift
        ;;
      --lines)
        dm_tools__flag__lines='1'
        shift
        ;;
      --words)
        dm_tools__flag__words='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__wc' \
          "Unexpected option '${1}'!" \
          'You can only use --chars, --lines or --words.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__wc' \
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
            'dm_tools__wc' \
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
  dm_tools__decision="${dm_tools__flag__chars}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__lines}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__words}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__path}"

  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__wc__common \
        "$dm_tools__decision" \
        "$dm_tools__value__path"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      # This if else construction is needed because POSIX does not have the
      # pipefail feature.
      if dm_tools__result="$( \
        _dm_tools__wc__common \
          "$dm_tools__decision" \
          "$dm_tools__value__path" \
      )"
      then
        # Some old BSD based wc implementations pads these results with empty
        # spaces, hence the additional xargs call.
        echo "$dm_tools__result" | xargs
      else
        dm_tools__status="$?"
        exit "$dm_tools__status"
      fi
      ;;

    *)
      dm_tools__report_incompatible_call 'dm_tools__wc'
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
_dm_tools__wc__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
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
        "$dm_tools__value__path" \

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
        "$dm_tools__value__path" \

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
        "$dm_tools__value__path" \

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
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__wc' \
        'Unexpected parameter combination!' \
        'You can only have either --chars, --lines or --words'
      ;;
  esac
}
