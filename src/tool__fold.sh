#==============================================================================
#
#   __       _     _
#  / _| ___ | | __| |
# | |_ / _ \| |/ _` |
# |  _| (_) | | (_| |
# |_|  \___/|_|\__,_|
#==============================================================================
# TOOL: FOLD
#==============================================================================

#==============================================================================
#
#  dm_tools__fold [--spaces] --width <line_width>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'fold' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --spaces - Use the fold compatible -s flag to break at spaces
#   --width <line_width> - Use the fold compatible -w flag.
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
dm_tools__fold() {
  dm_tools__flag__spaces='0'

  dm_tools__flag__width='0'
  dm_tools__value__width=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --spaces)
        dm_tools__flag__spaces='1'
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
          'dm_tools__fold' \
          "Unexpected option '${1}'!" \
          'You can only use --spaces and --width.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__fold' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__fold' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- spaces
  # |,---- width
  # 00
  dm_tools__decision="${dm_tools__flag__spaces}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__width}"

  _dm_tools__fold__common \
    "$dm_tools__decision" \
    "$dm_tools__value__width"
}

#==============================================================================
# Common based call mapping function.
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
_dm_tools__fold__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__width="$2"

  case "$dm_tools__decision_string" in
  # ,----- spaces
  # |,---- width
    00)
      fold \
        \
        \

      ;;
  # ,----- spaces
  # |,---- width
    01)
      fold \
        \
        -w "$dm_tools__value__width" \

      ;;
  # ,----- spaces
  # |,---- width
    10)
      fold \
        -s \
        \

      ;;
  # ,----- spaces
  # |,---- width
    11)
      fold \
        -s \
        -w "$dm_tools__value__width" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__fold' \
        'Unexpected parameter combination!' \
        'You can only use --spaces and --width.'
      ;;
  esac
}

