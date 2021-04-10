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
#  dm_tools__find <path>
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
#   DM_TOOLS__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   DM_TOOLS__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
dm_tools__find() {
  dm_tools__flag__type='0'
  dm_tools__value__type=''

  dm_tools__flag__name='0'
  dm_tools__value__name=''

  dm_tools__flag__max_depth='0'
  dm_tools__value__max_depth=''

  dm_tools__flag__same_file='0'
  dm_tools__value__same_file=''

  dm_tools__flag__print0='0'

  # This flag is only used to determine if the path was already set.
  dm_tools__flag__path='0'
  # This is a unusual processing of this positional parameter. As not all find
  # implementation has a default path, this value is always present and it is
  # only updated if needed. It is also independent of the decision string.
  dm_tools__value__path='.'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --type)
        dm_tools__flag__type='1'
        dm_tools__value__type="$2"
        shift
        shift
        ;;
      --name)
        dm_tools__flag__name='1'
        dm_tools__value__name="$2"
        shift
        shift
        ;;
      --max-depth)
        dm_tools__flag__max_depth='1'
        dm_tools__value__max_depth="$2"
        shift
        shift
        ;;
      --same-file)
        dm_tools__flag__same_file='1'
        dm_tools__value__same_file="$2"
        shift
        shift
        ;;
      --print0)
        dm_tools__flag__print0='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__find' \
          "Unexpected option '${1}'!" \
          'You can only use --type --name --max-depth --same-file --print0.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__find' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        # Only one file is needed for now.
        if [ "$dm_tools__flag__path" -eq '0' ]
        then
          dm_tools__flag__path='1'
          dm_tools__value__path="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__find' \
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
  dm_tools__decision="${dm_tools__flag__max_depth}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__type}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__name}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__same_file}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__print0}"

  _dm_tools__find__common \
    "$dm_tools__decision" \
    "$dm_tools__value__type" \
    "$dm_tools__value__name" \
    "$dm_tools__value__max_depth" \
    "$dm_tools__value__same_file" \
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
_dm_tools__find__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__type="$2"
  dm_tools__value__name="$3"
  dm_tools__value__max_depth="$4"
  dm_tools__value__same_file="$5"
  dm_tools__value__path="$6"

  case "$dm_tools__decision_string" in
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00000)
      find \
        "$dm_tools__value__path" \
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
        "$dm_tools__value__path" \
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
        "$dm_tools__value__path" \
        \
        \
        \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00011)
      find \
        "$dm_tools__value__path" \
        \
        \
        \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00100)
      find \
        "$dm_tools__value__path" \
        \
        \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        \
        \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        \
        \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    00111)
      find \
        "$dm_tools__value__path" \
        \
        \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01000)
      find \
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
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
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
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
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01011)
      find \
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01100)
      find \
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    01111)
      find \
        "$dm_tools__value__path" \
        \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10000)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10011)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10100)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    10111)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11000)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11011)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11100)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
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
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        \

      ;;
  # ,------ max_depth
  # |,----- type
  # ||,---- name
  # |||,--- same_file
  # ||||,-- print0
    11111)
      find \
        "$dm_tools__value__path" \
        -maxdepth "$dm_tools__value__max_depth" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -samefile "$dm_tools__value__same_file" \
        -print0 \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__find' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
