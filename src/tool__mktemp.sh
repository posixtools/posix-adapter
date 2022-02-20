#!/bin/sh
#==============================================================================
#             _    _
#   _ __ ___ | | _| |_ ___ _ __ ___  _ __
#  | '_ ` _ \| |/ / __/ _ \ '_ ` _ \| '_ \
#  | | | | | |   <| ||  __/ | | | | | |_) |
#  |_| |_| |_|_|\_\\__\___|_| |_| |_| .__/
#===================================|_|========================================
# TOOL: MKTEMP
#==============================================================================

#==============================================================================
#
#  dm_tools__mktemp [--directory] [--tmpdir <path>] <template>
#
#------------------------------------------------------------------------------
# Execution mapping function for the 'mktemp' command line tool with a
# uniform interface.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   --directory - Flag that indicates that a directory should be made.
#   --tmpdir <path> - Path prefix where the temp file/directory should be
#                     created into based on the template.
# Arguments:
#   [1] tempate - mktemp compatible template definition.
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
dm_tools__mktemp() {
  dm_tools__flag__directory='0'

  dm_tools__flag__tmpdir='0'
  dm_tools__value__tmpdir=''

  dm_tools__flag__template='0'
  dm_tools__value__template=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --directory)
        dm_tools__flag__directory='1'
        shift
        ;;
      --tmpdir)
        dm_tools__flag__tmpdir='1'
        dm_tools__value__tmpdir="$2"
        shift
        shift
        ;;
      --[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__mktemp' \
          "Unexpected option '${1}'!" \
          'You can only use --extended --silent --invert-match --count -- match-only.'
        ;;
      -[!-]*)
        dm_tools__report_invalid_parameters \
          'dm_tools__mktemp' \
          "Invalid single dashed option '${1}'!" \
          "dm_tools only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$dm_tools__flag__template" -eq '0' ]
        then
          dm_tools__flag__template='1'
          dm_tools__value__template="$1"
          shift
        else
          dm_tools__report_invalid_parameters \
            'dm_tools__mktemp' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$dm_tools__flag__template" -eq '0' ]
  then
    dm_tools__report_invalid_parameters \
      'dm_tools__mktemp' \
      'Missing <template> argument!' \
      'To be able to use grep, you need to specify at least a pattern.'
  fi

  # Assembling the decision string.
  # ,--- directory
  # |,-- tempdir
  # 00
  dm_tools__decision="${dm_tools__flag__directory}"
  dm_tools__decision="${dm_tools__decision}${dm_tools__flag__tmpdir}"

  case "$DM_TOOLS__RUNTIME__OS" in

    "$DM_TOOLS__CONSTANT__OS__LINUX")
      _dm_tools__mktemp__linux \
        "$dm_tools__decision" \
        "$dm_tools__value__tmpdir" \
        "$dm_tools__value__template"
      ;;

    "$DM_TOOLS__CONSTANT__OS__MACOS")
      _dm_tools__mktemp__darwin \
        "$dm_tools__decision" \
        "$dm_tools__value__tmpdir" \
        "$dm_tools__value__template"
      ;;

    *)
      dm_tools__report_incompatible_call 'dm_tools__mktemp'
      ;;
  esac
}

#==============================================================================
# Linux based call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_tmpdir - Tmpdir value.
#   [3] value_template - mktemp compatible template definition.
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
_dm_tools__mktemp__linux() {
  dm_tools__decision_string="$1"
  dm_tools__value__tmpdir="$2"
  dm_tools__value__template="$3"

  case "$dm_tools__decision_string" in
  # ,--- directory
  # |,-- tempdir
    00)
      mktemp \
        \
        \
        "$dm_tools__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    01)
      mktemp \
        \
        --tmpdir="$dm_tools__value__tmpdir" \
        "$dm_tools__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    10)
      mktemp \
        --directory \
        \
        "$dm_tools__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    11)
      mktemp \
        --directory \
        --tmpdir="$dm_tools__value__tmpdir" \
        "$dm_tools__value__template" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__mktemp' \
        'Unexpected parameter combination!' \
        'You can only have --directory --tmpdir.'
      ;;
  esac
}

#==============================================================================
# Darwin based call mapping function.
#------------------------------------------------------------------------------
# Globals:
#   None
# Options:
#   None
# Arguments:
#   [1] decision_string - String that decodes the optional parameter presence.
#   [2] value_tmpdir - Tmpdir value.
#   [3] value_template - mktemp compatible template definition.
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
_dm_tools__mktemp__darwin() {
  dm_tools__decision_string="$1"
  dm_tools__value__tmpdir="$2"
  dm_tools__value__template="$3"

  case "$dm_tools__decision_string" in
  # ,--- directory
  # |,-- tempdir
    00)
      mktemp \
        \
        "$dm_tools__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    01)
      mktemp \
        \
        "${dm_tools__value__tmpdir}/${dm_tools__value__template}" \

      ;;
  # ,--- directory
  # |,-- tempdir
    10)
      mktemp \
        -d \
        "$dm_tools__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    11)
      mktemp \
        -d \
        "${dm_tools__value__tmpdir}/${dm_tools__value__template}" \

      ;;
    *)
      dm_tools__report_invalid_parameters \
        'dm_tools__mktemp' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
