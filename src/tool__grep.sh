#!/bin/sh
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
#    [path]
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
#   [2] [path] - Optional file path in which grep should operate.
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

  dm_tools__flag__path='0'
  dm_tools__value__path=''

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
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__grep' \
          "Unexpected option '${1}'!" \
          'You can only use --extended --silent --invert-match --count --match-only.'
        ;;
      -[!-]*)
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
          if [ "$dm_tools__flag__path" -eq '0' ]
          then
            dm_tools__flag__path='1'
            dm_tools__value__path="$1"
            shift
          else
            dm_tools__report_invalid_parameters \
              'dm_tools__grep' \
              'Unexpected parameter!' \
              "Parameter '${1}' is unexpected!"
          fi
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
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
  # 000000
  dm_tools__decision="${dm_tools__flag__extended}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__silent}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__invert_match}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__count}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__match_only}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__path}"

  _dm_tools__grep__common \
    "$dm_tools__decision" \
    "$dm_tools__value__pattern" \
    "$dm_tools__value__path"
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
#   [3] value_path - Path in which the search should be executed.
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
  dm_tools__value__path="$3"

  case "$dm_tools__decision_string" in
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000000)
      grep \
        \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000001)
      grep \
        \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000010)
      grep \
        \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000011)
      grep \
        \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000100)
      grep \
        \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000101)
      grep \
        \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000110)
      grep \
        \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    000111)
      grep \
        \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001000)
      grep \
        \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001001)
      grep \
        \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001010)
      grep \
        \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001011)
      grep \
        \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001100)
      grep \
        \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001101)
      grep \
        \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001110)
      grep \
        \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    001111)
      grep \
        \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010000)
      grep \
        \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010001)
      grep \
        \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010010)
      grep \
        \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010011)
      grep \
        \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010100)
      grep \
        \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010101)
      grep \
        \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010110)
      grep \
        \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    010111)
      grep \
        \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011000)
      grep \
        \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011001)
      grep \
        \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011010)
      grep \
        \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011011)
      grep \
        \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011100)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011101)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011110)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    011111)
      grep \
        \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100000)
      grep \
        -E \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100001)
      grep \
        -E \
        \
        \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100010)
      grep \
        -E \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100011)
      grep \
        -E \
        \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100100)
      grep \
        -E \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100101)
      grep \
        -E \
        \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100110)
      grep \
        -E \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    100111)
      grep \
        -E \
        \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101000)
      grep \
        -E \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101001)
      grep \
        -E \
        \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101010)
      grep \
        -E \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101011)
      grep \
        -E \
        \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101100)
      grep \
        -E \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101101)
      grep \
        -E \
        \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101110)
      grep \
        -E \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    101111)
      grep \
        -E \
        \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110000)
      grep \
        -E \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110001)
      grep \
        -E \
        --silent \
        \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110010)
      grep \
        -E \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110011)
      grep \
        -E \
        --silent \
        \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110100)
      grep \
        -E \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110101)
      grep \
        -E \
        --silent \
        \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110110)
      grep \
        -E \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    110111)
      grep \
        -E \
        --silent \
        \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111000)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111001)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111010)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111011)
      grep \
        -E \
        --silent \
        --invert-match \
        \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111100)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111101)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111110)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        \

      ;;
  # ,------- extended
  # |,------ silent
  # ||,----- invert_match
  # |||,---- count
  # ||||,--- match_only
  # |||||,-- path
    111111)
      grep \
        -E \
        --silent \
        --invert-match \
        --count \
        --only-matching \
        "$dm_tools__value__pattern" \
        "$dm_tools__value__path" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__grep' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
