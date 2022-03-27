#!/bin/sh
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
#  posix_adapter__cut --delimiter <delimiter_char> --fields <index_def> [file]
#  posix_adapter__cut --characters <index_def> [file]
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__cut() {
  posix_adapter__flag__delimiter='0'
  posix_adapter__value__delimiter=''

  posix_adapter__flag__fields='0'
  posix_adapter__value__fields=''

  posix_adapter__flag__characters='0'
  posix_adapter__value__characters=''

  posix_adapter__flag__file='0'
  posix_adapter__value__file=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --delimiter)
        posix_adapter__flag__delimiter='1'
        posix_adapter__value__delimiter="$2"
        shift
        shift
        ;;
      --fields)
        posix_adapter__flag__fields='1'
        posix_adapter__value__fields="$2"
        shift
        shift
        ;;
      --characters)
        posix_adapter__flag__characters='1'
        posix_adapter__value__characters="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__cut' \
          "Unexpected option '${1}'!" \
          'You can only use (--delimiter --fields) or (--characters).'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__cut' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        # Only one file is needed for now.
        if [ "$posix_adapter__flag__file" -eq '0' ]
        then
          posix_adapter__flag__file='1'
          posix_adapter__value__file="$1"
          shift
        else
          posix_adapter__report_invalid_parameters \
            'posix_adapter__cut' \
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
  posix_adapter__decision="${posix_adapter__flag__delimiter}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__fields}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__characters}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__file}"

  _posix_adapter__cut__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__delimiter" \
    "$posix_adapter__value__fields" \
    "$posix_adapter__value__characters" \
    "$posix_adapter__value__file"
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
_posix_adapter__cut__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__delimiter="$2"
  posix_adapter__value__fields="$3"
  posix_adapter__value__characters="$4"
  posix_adapter__value__file="$5"

  case "$posix_adapter__decision_string" in
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    1100)
      cut \
        -d "$posix_adapter__value__delimiter" \
        -f "$posix_adapter__value__fields" \
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
        -c "$posix_adapter__value__characters" \
        \

      ;;
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    1101)
      cut \
        -d "$posix_adapter__value__delimiter" \
        -f "$posix_adapter__value__fields" \
        \
        "$posix_adapter__value__file" \

      ;;
  # ,----- delimiter
  # |,---- fields
  # ||,--- characters
  # |||,-- file
    0011)
      cut \
        \
        \
        -c "$posix_adapter__value__characters" \
        "$posix_adapter__value__file" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__cut' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
