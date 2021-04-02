#==============================================================================
#
#  _   _ _ __   __ _ _ __ ___   ___
# | | | | '_ \ / _` | '_ ` _ \ / _ \
# | |_| | | | | (_| | | | | | |  __/
#  \__,_|_| |_|\__,_|_| |_| |_|\___|
#==============================================================================
# TOOL: UNAME
#==============================================================================

#==============================================================================
#
#  dm_tools__uname
#    [--kernel-name]
#    [--kernel-release]
#    [--machine]
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'uname' command line tool with a uniform
# interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --kernel-name - uname compatible kernel name flag.
#   --kernel-release - uname compatible kernel release flag.
#   --machine - uname compatible machine flag.
# Arguments:
#   None
# STDIN:
#   None
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
dm_tools__uname() {
  dm_tools__flag__kernel_name='0'
  dm_tools__flag__kernel_release='0'
  dm_tools__flag__machine='0'

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --kernel-name)
        dm_tools__flag__kernel_name='1'
        shift
        ;;
      --kernel-release)
        dm_tools__flag__kernel_release='1'
        shift
        ;;
      --machine)
        dm_tools__flag__machine='1'
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__uname' \
          "Unexpected option '${1}'!" \
          'You can only use --kernel-name --kernel-release and --machine.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__uname' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        dm_tools__report_invalid_parameters \
          'dm_tools__uname' \
          'Unexpected parameter!' \
          "Parameter '${1}' is unexpected!"
        ;;
    esac
  done

  # Assembling the decision string.
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
  # 000
  dm_tools__decision="${dm_tools__flag__kernel_name}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__kernel_release}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__machine}"

  _dm_tools__uname__common \
    "$dm_tools__decision"
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
_dm_tools__uname__common() {
  dm_tools__decision_string="$1"

  case "$dm_tools__decision_string" in
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    000)
      uname \
        \
        \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    001)
      uname \
        \
        \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    010)
      uname \
        \
        -r \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    011)
      uname \
        \
        -r \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    100)
      uname \
        -s \
        \
        \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    101)
      uname \
        -s \
        \
        -m \

      ;;
  # ,------ kernel_name
  # |,----- kernel_release
  # ||,---- machine
    111)
      uname \
        -s \
        -r \
        -m \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__uname' \
        'Unexpected parameter combination!' \
        'You can only have --kernel_name --kernel_release --machine.'
      ;;
  esac
}
