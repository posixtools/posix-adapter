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
      --print0)
        dm_tools__flag__print0='1'
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__find' \
          "Unexpected option '${1}'!" \
          'You can only use (--delimiter --fields) or (--characters).'
        ;;
      -[^-]*)
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

  # Assembling the decision string.
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
  # 0000
  dm_tools__decision="${dm_tools__flag__type}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__name}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__max_depth}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__print0}"

  _dm_tools__find__common \
    "$dm_tools__decision" \
    "$dm_tools__value__type" \
    "$dm_tools__value__name" \
    "$dm_tools__value__max_depth" \
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
#   [5] value_path - Path that should be the base of the search.
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
  dm_tools__value__path="$5"

  case "$dm_tools__decision_string" in
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0000)
      find \
        "$dm_tools__value__path" \
        \
        \
        \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0001)
      find \
        "$dm_tools__value__path" \
        \
        \
        \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0010)
      find \
        "$dm_tools__value__path" \
        \
        \
        -maxdepth "$dm_tools__value__max_depth" \
        \

      ;;
  # ,----- type
  # |n---- name
  # ||,--- max_depth
  # |||,-- print0
    0011)
      find \
        "$dm_tools__value__path" \
        \
        \
        -maxdepth "$dm_tools__value__max_depth" \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0100)
      find \
        "$dm_tools__value__path" \
        \
        -name "$dm_tools__value__name" \
        \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0101)
      find \
        "$dm_tools__value__path" \
        \
        -name "$dm_tools__value__name" \
        \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0110)
      find \
        "$dm_tools__value__path" \
        \
        -name "$dm_tools__value__name" \
        -maxdepth "$dm_tools__value__max_depth" \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    0111)
      find \
        "$dm_tools__value__path" \
        \
        -name "$dm_tools__value__name" \
        -maxdepth "$dm_tools__value__max_depth" \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1000)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        \
        \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1001)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        \
        \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1010)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        \
        -maxdepth "$dm_tools__value__max_depth" \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1011)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        \
        -maxdepth "$dm_tools__value__max_depth" \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1100)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1101)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        \
        -print0 \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1110)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -maxdepth "$dm_tools__value__max_depth" \
        \

      ;;
  # ,----- type
  # |,---- name
  # ||,--- max_depth
  # |||,-- print0
    1111)
      find \
        "$dm_tools__value__path" \
        -type "$dm_tools__value__type" \
        -name "$dm_tools__value__name" \
        -maxdepth "$dm_tools__value__max_depth" \
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
