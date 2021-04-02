#==============================================================================
#
# __  ____ _ _ __ __ _ ___
# \ \/ / _` | '__/ _` / __|
#  >  < (_| | | | (_| \__ \
# /_/\_\__,_|_|  \__, |___/
#================|___/=========================================================
# TOOL: XARGS
#==============================================================================

#==============================================================================
#
#  dm_tools__xargs
#    [--null]
#    [--replace <replace_string>]
#    [--max-args <arg_count>]
#    [..]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'xargs' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --null - xargs compatible -0 flag.
#   --replace <replace_string> - xargs compatible -I flag.
#   --max-args - xargs compatible -n flag.
# Arguments:
#   None
# STDIN:
#   Standard input for the command.
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
dm_tools__xargs() {
  dm_tools__flag__null='0'

  dm_tools__flag__replace='0'
  dm_tools__value__replace='0'

  dm_tools__flag__max_args='0'
  dm_tools__value__max_args='0'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --null)
        dm_tools__flag__null='1'
        shift
        ;;
      --replace)
        dm_tools__flag__replace='1'
        dm_tools__value__replace="$2"
        shift
        shift
        ;;
      --max-args)
        dm_tools__flag__max_args='1'
        dm_tools__value__max_args="$2"
        shift
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__xargs' \
          "Unexpected option '${1}'!" \
          'You can only use --null --replace --max-args.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__xargs' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        # We are breaking here to have all the additional parameters available
        # in the '@' variable.
        break
        ;;
    esac
  done

  # Assembling the decision string.
  # ,------ null
  # |,----- replace
  # ||,---- max_args
  # 000
  dm_tools__decision="${dm_tools__flag__null}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__replace}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__max_args}"

  _dm_tools__xargs__common \
    "$dm_tools__decision" \
    "$dm_tools__value__replace" \
    "$dm_tools__value__max_args" \
    "$@"
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
#   [2] value_replace - Value for the replace option.
#   [3] value_max_args - Value for the max args option.
#   [..] additionals - Additional variables.
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
_dm_tools__xargs__common() {
  dm_tools__decision_string="$1"
  shift
  dm_tools__value__replace="$1"
  shift
  dm_tools__value__max_args="$1"
  shift

  case "$dm_tools__decision_string" in
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    000)
      xargs \
        \
        \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    001)
      xargs \
        \
        \
        -n "$dm_tools__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    010)
      xargs \
        \
        -I "$dm_tools__value__replace" \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    011)
      xargs \
        \
        -I "$dm_tools__value__replace" \
        -n "$dm_tools__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    100)
      xargs \
        -0 \
        \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    101)
      xargs \
        -0 \
        \
        -n "$dm_tools__value__max_args" \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    110)
      xargs \
        -0 \
        -I "$dm_tools__value__replace" \
        \
        "$@" \

      ;;
  # ,------ null
  # |,----- replace
  # ||,---- max_args
    111)
      xargs \
        -0 \
        -I "$dm_tools__value__replace" \
        -n "$dm_tools__value__max_args" \
        "$@" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__xargs' \
        'Unexpected parameter combination!' \
        'You can only use --null --replace --max-args.'
      ;;
  esac
}
