#!/bin/sh
#==============================================================================
#   _
#  | |_ _ __
#  | __| '__|
#  | |_| |
#   \__|_|
#==============================================================================
# TOOL: TR
#==============================================================================

#==============================================================================
#
#  posix_adapter__tr
#    [--delete <char>]
#    [--replace <target> <value>]
#    [--squeeze-repeats <char>]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'tr' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --delete <char> - tr compatible --delete flag.
#   --replace <target> <value> - Default tr functionality put behind an option
#                                to make it more explicit.
#   --squeeze-repeats <char> - Deletes repeated occurences of the given
#                              character or character class.
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__tr() {
  posix_adapter__flag__delete='0'
  posix_adapter__value__delete=''

  posix_adapter__flag__replace='0'
  posix_adapter__value__replace__target=''
  posix_adapter__value__replace__value=''

  posix_adapter__flag__squeeze='0'
  posix_adapter__value__squeeze=''

  while [ "$#" -gt '0' ]
  do
    posix_adapter__param="$1"
    case "$posix_adapter__param" in
      --delete)
        posix_adapter__flag__delete='1'
        posix_adapter__value__delete="$2"
        shift
        shift
        ;;
      --replace)
        posix_adapter__flag__replace='1'
        posix_adapter__value__replace__target="$2"
        posix_adapter__value__replace__value="$3"
        shift
        shift
        shift
        ;;
      --squeeze-repeats)
        posix_adapter__flag__squeeze='1'
        posix_adapter__value__squeeze="$2"
        shift
        shift
        ;;
    --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__tr' \
          "Unexpected option '${1}'!" \
          'Only --delete or --replace or --squeeze-repeats is available.'
        ;;
    -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__tr' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__tr' \
          'Unexpected parameter!' \
          'Only options are available.'
        ;;
    esac
  done

  # Assembling the decision string.
  # ,---- delete
  # |,--- replace
  # ||,-- squeeze_repeats
  # 000
  posix_adapter__decision="${posix_adapter__flag__delete}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__replace}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__squeeze}"

  _posix_adapter__tr__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__delete" \
    "$posix_adapter__value__replace__target" \
    "$posix_adapter__value__replace__value" \
    "$posix_adapter__value__squeeze"
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
#   [2] value_delete -  Value passed with the delete option.
#   [3] value_replace_target -  Target value passed with the replace option.
#   [4] value_replace_value -  Value passed with the replace option.
#   [5] value_squeeze -  Value passed with the squeeze repeats option.
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
_posix_adapter__tr__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__delete="$2"
  posix_adapter__value__replace__target="$3"
  posix_adapter__value__replace__value="$4"
  posix_adapter__value__squeeze="$5"

  case "$posix_adapter__decision_string" in
  # ,---- delete
  # |,--- replace
  # ||,-- squeeze_repeats
    001)
      tr \
        \
        \
        -s "$posix_adapter__value__squeeze" \

      ;;
  # ,---- delete
  # |,--- replace
  # ||,-- squeeze_repeats
    010)
      tr \
        \
        "$posix_adapter__value__replace__target" "$posix_adapter__value__replace__value" \
        \

      ;;
  # ,---- delete
  # |,--- replace
  # ||,-- squeeze_repeats
    100)
      tr \
        -d "$posix_adapter__value__delete" \
        \
        \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__tr' \
        'Unexpected parameter combination!' \
        'Only --delete or --replace  or --squeeze-repeats is available.'
      ;;
  esac
}
