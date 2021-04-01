#==============================================================================
#   __ _ _ __ ___ _ __
#  / _` | '__/ _ \ '_ \
# | (_| | | |  __/ |_) |
#  \__, |_|  \___| .__/
#==|___/=========|_|===========================================================
# TOOL: GREP
#==============================================================================

#==============================================================================
#
#  dm_tools__grep
#    [--extended]
#    [--silent]
#    [--invert-match]
#    [--count]
#    [--match-only]
#    <pattern>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'echo' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --extended - Use extended regular expression.
#   --silent - Use silent mode.
#   --invert-match - Use the inverted match feature.
#   --count - Use count feature.
#   --match-only - Use the only matching feature.
# Arguments:
#   [1] pattern - grep compatible pattern.
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
dm_tools__grep() {
  dm_tools__flag__extended='0'
  dm_tools__flag__silent='0'
  dm_tools__flag__invert_match='0'
  dm_tools__flag__count='0'
  dm_tools__flag__match_only='0'

  dm_tools__flag__pattern='0'
  dm_tools__value__pattern=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --extended)
        dm_tools__flag__extended='1'
        shift
        ;;
      --silent)
        dm_tools__flag__silent='1'
        shift
        ;;
      --invert-match)
        dm_tools__flag__invert_match='1'
        shift
        ;;
      --count)
        dm_tools__flag__count='1'
        shift
        ;;
      --match-only)
        dm_tools__flag__match_only='1'
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__grep' \
          "Unexpected option '${1}'!" \
          'You can only use --extended --silent --invert-match --count --match-only.'
        ;;
      -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__grep' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__pattern" -eq '0' ]
        then
          dm_tools__flag__pattern='1'
          dm_tools__value__pattern="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__grep' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__pattern" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__grep' \
      'Missing <pattern> argument!' \
      'To be able to use grep, you need to specify at least a pattern.'
  fi

  # Assembling the decision string.
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
  # 00000
  dm_tools__decision="${dm_tools__flag__extended}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__silent}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__invert_match}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__count}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__match_only}"

  _dm_tools__grep__common \
    "$dm_tools__decision" \
    "$dm_tools__value__pattern"
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
#   [2] value_pattern - Grep compatible pattern value.
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
_dm_tools__grep__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__pattern="$2"

  case "$dm_tools__decision_string" in
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00000)
      grep \
        \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00001)
      grep \
        \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00010)
      grep \
        \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00011)
      grep \
        \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00100)
      grep \
        \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00101)
      grep \
        \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00110)
      grep \
        \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    00111)
      grep \
        \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01000)
      grep \
        \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01001)
      grep \
        \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01010)
      grep \
        \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01011)
      grep \
        \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01100)
      grep \
        \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01101)
      grep \
        \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01110)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    01111)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10000)
      grep \
        -E \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10001)
      grep \
        -E \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10010)
      grep \
        -E \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10011)
      grep \
        -E \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10100)
      grep \
        -E \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10101)
      grep \
        -E \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10110)
      grep \
        -E \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    10111)
      grep \
        -E \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11000)
      grep \
        -E \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11001)
      grep \
        -E \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11010)
      grep \
        -E \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11011)
      grep \
        -E \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11100)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11101)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11110)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \

      ;;
  # ,------ extended
  # |,----- silent
  # ||,---- invert_match
  # |||,--- count
  # ||||,-- match_only
    11111)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__grep' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
