#==============================================================================
#             _
#   ___ _   _| |_
#  / __| | | | __|
# | (__| |_| | |_
#  \___|\__,_|\__|
#==============================================================================
# TOOL: CUT
#==============================================================================

#==============================================================================
#
#  dm_tools__cut --delimiter <delimiter_char> --fields <index_def> [file]
#  dm_tools__cut --characters <index_def> [file]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'cut' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --delimiter <delimiter_char> - cut compatible delimiter definition
#   --fields <index_definition> - cut compatible fields definition
#   --characters <index_definition> - cut compatible characters definition
# Arguments:
#   [1] [file] - File that should be processed.
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
dm_tools__cut() {
  dm_tools__flag__delimiter='0'
  dm_tools__value__delimiter=''

  dm_tools__flag__fields='0'
  dm_tools__value__fields=''

  dm_tools__flag__characters='0'
  dm_tools__value__characters=''

  dm_tools__flag__file='0'
  dm_tools__value__file=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --delimiter)
        dm_tools__flag__delimiter='1'
        dm_tools__value__delimiter="$2"
        shift
        shift
        ;;
      --fields)
        dm_tools__flag__fields='1'
        dm_tools__value__fields="$2"
        shift
        shift
        ;;
      --characters)
        dm_tools__flag__characters='1'
        dm_tools__value__characters="$2"
        shift
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__cut' \
          "Unexpected option '${1}'!" \
          'You can only use (--delimiter --fields) or (--characters).'
        ;;
      -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__cut' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        # Only one file is needed for now.
        if [ "$dm_tools__flag__file" -eq '0' ]
        then
          dm_tools__flag__file='1'
          dm_tools__value__file="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__cut' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string.
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
  # 0000
  dm_tools__decision="${dm_tools__flag__delimiter}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__fields}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__characters}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__file}"

  _dm_tools__cut__common \
    "$dm_tools__decision" \
    "$dm_tools__value__delimiter" \
    "$dm_tools__value__fields" \
    "$dm_tools__value__characters" \
    "$dm_tools__value__file"
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
#   [2] value_delimiter -  Value passed with the delimiter flag.
#   [3] value_fields - Value passed with the fields flag.
#   [4] value_characters - Value passed with the characters flag.
#   [5] value_file - File path input that should be processed, otherwise the
#       standard input will be read.
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
_dm_tools__cut__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__delimiter="$2"
  dm_tools__value__fields="$3"
  dm_tools__value__characters="$4"
  dm_tools__value__file="$5"

  case "$dm_tools__decision_string" in
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    1100)
      cut \
        -d "$dm_tools__value__delimiter" \
        -f "$dm_tools__value__fields" \
        \
        \

      ;;
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    0010)
      cut \
        \
        \
        -c "$dm_tools__value__characters" \
        \

      ;;
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    1101)
      cut \
        -d "$dm_tools__value__delimiter" \
        -f "$dm_tools__value__fields" \
        \
        "$dm_tools__value__file" \

      ;;
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    0011)
      cut \
        \
        \
        -c "$dm_tools__value__characters" \
        "$dm_tools__value__file" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__cut' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
