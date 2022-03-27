#!/bin/sh
#==============================================================================
#    __ _           _
#   / _(_)_ __   __| |
#  | |_| | '_ \ / _` |
#  |  _| | | | | (_| |
#  |_| |_|_| |_|\__,_|
#==============================================================================
# TOOL: FIND
#==============================================================================

#==============================================================================
#
#  posix_adapter__find <path>
#    [--type <type>]
#    [--name <name>]
#    [--max-depth <depth>]
#    [--same-file <path>]
#    [--print0]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'find' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --type <type> - find compatible type specifier string.
#   --name <name> - find compatible name specifier string.
#   --max-depth <depth> - find compatible search depth specifier.
#   --same-file <path> - find compatible same file parameter.
#   --print0 - print null separated results.
# Arguments:
#   [1] path - Path where the search should be executed.
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
posix_adapter__find() {
  posix_adapter__flag__type='0'
  posix_adapter__value__type=''

  posix_adapter__flag__name='0'
  posix_adapter__value__name=''

  posix_adapter__flag__max_depth='0'
  posix_adapter__value__max_depth=''

  posix_adapter__flag__same_file='0'
  posix_adapter__value__same_file=''

  posix_adapter__flag__print0='0'

  # This flag is only used to determine if the path was already set.
  posix_adapter__flag__path='0'
  # This is a unusual processing of this positional parameter. As not all find
  # implementation has a default path, this value is always present and it is
  # only updated if needed. It is also independent of the decision string.
  posix_adapter__value__path='.'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --type)
        posix_adapter__flag__type='1'
        posix_adapter__value__type="$2"
        shift
        shift
        ;;
      --name)
        posix_adapter__flag__name='1'
        posix_adapter__value__name="$2"
        shift
        shift
        ;;
      --max-depth)
        posix_adapter__flag__max_depth='1'
        posix_adapter__value__max_depth="$2"
        shift
        shift
        ;;
      --same-file)
        posix_adapter__flag__same_file='1'
        posix_adapter__value__same_file="$2"
        shift
        shift
        ;;
      --print0)
        posix_adapter__flag__print0='1'
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__find' \
          "Unexpected option '${1}'!" \
          'You can only use --type --name --max-depth --same-file --print0.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__find' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        # Only one file is needed for now.
        if [ "$posix_adapter__flag__path" -eq '0' ]
        then
          posix_adapter__flag__path='1'
          posix_adapter__value__path="$1"
          shift
        else
          posix_adapter__report_invalid_parameters \
            'posix_adapter__find' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  # Assembling the decision string. Max depth sohuld be the first as find
  # processes its parameters sequentially. MAx-depth - type - name should be
  # the priority order.
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
  # 00000
  posix_adapter__decision="${posix_adapter__flag__max_depth}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__type}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__name}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__same_file}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__print0}"

  _posix_adapter__find__common \
    "$posix_adapter__decision" \
    "$posix_adapter__value__type" \
    "$posix_adapter__value__name" \
    "$posix_adapter__value__max_depth" \
    "$posix_adapter__value__same_file" \
    "$posix_adapter__value__path"
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
#   [2] value_type -  Value passed with the type flag.
#   [3] value_name - Value passed with the name flag.
#   [4] value_max_depth - Value passed with the max_depth flag.
#   [5] value_same_file - Value passed with the same_file flag.
#   [6] value_path - Path that should be the base of the search.
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
_posix_adapter__find__common() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__type="$2"
  posix_adapter__value__name="$3"
  posix_adapter__value__max_depth="$4"
  posix_adapter__value__same_file="$5"
  posix_adapter__value__path="$6"

  case "$posix_adapter__decision_string" in
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00000)
      find \
        "$posix_adapter__value__path" \
        \
        \
        \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00001)
      find \
        "$posix_adapter__value__path" \
        \
        \
        \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00010)
      find \
        "$posix_adapter__value__path" \
        \
        \
        \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00011)
      find \
        "$posix_adapter__value__path" \
        \
        \
        \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00100)
      find \
        "$posix_adapter__value__path" \
        \
        \
        -name "$posix_adapter__value__name" \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00101)
      find \
        "$posix_adapter__value__path" \
        \
        \
        -name "$posix_adapter__value__name" \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00110)
      find \
        "$posix_adapter__value__path" \
        \
        \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00111)
      find \
        "$posix_adapter__value__path" \
        \
        \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01000)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01001)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01010)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01011)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01100)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01101)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01110)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01111)
      find \
        "$posix_adapter__value__path" \
        \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10000)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10001)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10010)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10011)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10100)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        -name "$posix_adapter__value__name" \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10101)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        -name "$posix_adapter__value__name" \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10110)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10111)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11000)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11001)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11010)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11011)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11100)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11101)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11110)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11111)
      find \
        "$posix_adapter__value__path" \
        -maxdepth "$posix_adapter__value__max_depth" \
        -type "$posix_adapter__value__type" \
        -name "$posix_adapter__value__name" \
        -samefile "$posix_adapter__value__same_file" \
        -print0 \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__find' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
