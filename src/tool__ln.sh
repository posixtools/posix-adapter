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
#  dm_tools__ln
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__ln() {
  dm_tools__flag__symbolic='0'
  dm_tools__flag__verbose='0'

  dm_tools__flag__target='0'
  dm_tools__value__target=''

  dm_tools__flag__link_name='0'
  dm_tools__value__link_name=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --symbolic)
        dm_tools__flag__symbolic='1'
        shift
        ;;
      --verbose)
        dm_tools__flag__verbose='1'
        shift
        ;;
      --target)
        dm_tools__flag__target='1'
        dm_tools__value__target="$2"
        shift
        shift
        ;;
      --link-name)
        dm_tools__flag__link_name='1'
        dm_tools__value__link_name="$2"
        shift
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__ln' \
          "Unexpected option '${1}'!" \
          'Only --symbolic --verbose --target and --link-name are available.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__ln' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__ln' \
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
  dm_tools__decision="${dm_tools__flag__symbolic}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__verbose}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__target}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__link_name}"

  _dm_tools__ln__common \
    "$dm_tools__decision" \
    "$dm_tools__value__target" \
    "$dm_tools__value__link_name"
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
_dm_tools__ln__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__target_path="$2"
  dm_tools__value__link_name="$3"

  case "$dm_tools__decision_string" in
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    0011)
      ln \
        \
        \
        "$dm_tools__value__target_path" \
        "$dm_tools__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    0111)
      ln \
        \
        -v \
        "$dm_tools__value__target_path" \
        "$dm_tools__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    1011)
      ln \
        -s \
        \
        "$dm_tools__value__target_path" \
        "$dm_tools__value__link_name" \

      ;;
  # ,----- symbolic
  # |,---- verbose
  # ||,--- target
  # |||,-- link_name
    1111)
      ln \
        -s \
        -v \
        "$dm_tools__value__target_path" \
        "$dm_tools__value__link_name" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__ln' \
        'Unexpected parameter combination!' \
        'Only --symbolic --verbose are optional -target and --link_name are mandatory.'
      ;;
  esac
}
