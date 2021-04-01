#==============================================================================
#
#   _ __ _ __ ___
#  | '__| '_ ` _ \
#  | |  | | | | | |
#  |_|  |_| |_| |_|
#==============================================================================
# TOOL: RM
#==============================================================================

#==============================================================================
#
#  dm_tools__rm [--recursive] [--force] <path>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'rm' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --recursive - rm compatible flag for the -r flag.
#   --force - rm compatible flag for the -f flag.
# Arguments:
#   [1] path - Path that should be removed.
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
dm_tools__rm() {
  dm_tools__flag__recursive='0'
  dm_tools__flag__force='0'

  dm_tools__flag__path='0'
  dm_tools__value__path=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --recursive)
        dm_tools__flag__recursive='1'
        shift
        ;;
      --force)
        dm_tools__flag__force='1'
        shift
        ;;
      --[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__rm' \
          "Unexpected option '${1}'!" \
          'You can only use --recursive and --force.'
        ;;
      -[^-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__rm' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__path" -eq '0' ]
        then
          dm_tools__flag__path='1'
          dm_tools__value__path="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__rm' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__path" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__rm' \
      'Missing <path> argument!' \
      'To be able to use rm, you need to specify a path to work with.'
  fi

  # Assembling the decision string.
  # ,--- recursive
  # |,-- force
  # 00
  dm_tools__decision="${dm_tools__flag__recursive}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__force}"

  _dm_tools__rm__common \
    "$dm_tools__decision" \
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
#   [2] value_path - Path value.
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
_dm_tools__rm__common() {
  dm_tools__decision_string="$1"
  dm_tools__value__path="$2"

  case "$dm_tools__decision_string" in
  # ,--- recursive
  # |,-- force
    00)
      rm \
        \
        \
        "${dm_tools__value__path}" \

      ;;
  # ,--- recursive
  # |,-- force
    01)
      rm \
        \
        -f \
        "${dm_tools__value__path}" \

      ;;
  # ,--- recursive
  # |,-- force
    10)
      rm \
        -r \
        \
        "${dm_tools__value__path}" \

      ;;
  # ,--- recursive
  # |,-- force
    11)
      rm \
        -r \
        -f \
        "${dm_tools__value__path}" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__rm' \
        'Unexpected parameter combination!' \
        'You can only have --no-symlink.'
      ;;
  esac
}
