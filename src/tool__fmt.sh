#==============================================================================
#
#   __           _
#  / _|_ __ ___ | |_
# | |_| '_ ` _ \| __|
# |  _| | | | | | |_
# |_| |_| |_| |_|\__|
#==============================================================================
# TOOL: FMT
#==============================================================================

#==============================================================================
#
#  dm_tools__fmt [--split-only] --width <line_width>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'fmt' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --split-only - Use the modern fmt compatible -s flag.
#   --width <line_width> - Use the fmt compatible -w flag.
# Arguments:
#   None
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
dm_tools__fmt() {
  dm_tools__flag__split_only='0'

  dm_tools__flag__width='0'
  dm_tools__value__width=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --split-only)
        dm_tools__flag__split_only='1'
        shift
        ;;
      --width)
        dm_tools__flag__width='1'
        dm_tools__value__width="$2"
        shift
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__fmt' \
          "Unexpected option '${1}'!" \
          'You can only use --split-only and --width.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__fmt' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__fmt' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- split_only
  # |,---- width
  # 00
  dm_tools__decision="${dm_tools__flag__split_only}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__width}"

  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__fmt__linux \
        "$dm_tools__decision" \
        "$dm_tools__value__width"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__fmt__macos \
        "$dm_tools__decision" \
        "$dm_tools__value__width"
      ;;

    *)
      dm_tools__report_incompatible_call 'dm_tools__fmt'
      ;;
  esac
}

#==============================================================================
# Linux based call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_width - Value for optional width parameter.
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
_dm_tools__fmt__linux() {
  dm_tools__decision_string="$1"
  dm_tools__value__width="$2"

  case "$dm_tools__decision_string" in
  # ,----- split_only
  # |,---- width
    00)
      fmt \
        \
        \

      ;;
  # ,----- split_only
  # |,---- width
    01)
      fmt \
        \
        --width "$dm_tools__value__width" \

      ;;
  # ,----- split_only
  # |,---- width
    10)
      fmt \
        --split-only \
        \

      ;;
  # ,----- split_only
  # |,---- width
    11)
      fmt \
        --split-only \
        --width "$dm_tools__value__width" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__fmt' \
        'Unexpected parameter combination!' \
        'You can only use --split-only and --width.'
      ;;
  esac
}

#==============================================================================
# Macos based call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_width - Value for optional width parameter.
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
_dm_tools__fmt__linux() {
  dm_tools__decision_string="$1"
  dm_tools__value__width="$2"

  case "$dm_tools__decision_string" in
  # ,----- split_only
  # |,---- width
    00)
      fmt \
        \
        \

      ;;
  # ,----- split_only
  # |,---- width
    01)
      fmt \
        \
        -w "$dm_tools__value__width" \

      ;;
  # ,----- split_only
  # |,---- width
    10)
      fmt \
        -s \
        \

      ;;
  # ,----- split_only
  # |,---- width
    11)
      fmt \
        -s \
        -w "$dm_tools__value__width" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__fmt' \
        'Unexpected parameter combination!' \
        'You can only use --split-only and --width.'
      ;;
  esac
}
