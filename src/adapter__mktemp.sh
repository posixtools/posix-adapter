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
#  posix_adapter__mktemp [--directory] [--tmpdir <path>] <template>
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
#   POSIX_ADAPTER__STATUS__INVALID_PARAMETERS - Invalid parameter configuration.
#   POSIX_ADAPTER__STATUS__INCOMPATIBLE_CALL - No compatible call style was found.
#==============================================================================
posix_adapter__mktemp() {
  posix_adapter__flag__directory='0'

  posix_adapter__flag__tmpdir='0'
  posix_adapter__value__tmpdir=''

  posix_adapter__flag__template='0'
  posix_adapter__value__template=''

  while [ "$#" -gt '0' ]
  do
    case "$1" in
      --directory)
        posix_adapter__flag__directory='1'
        shift
        ;;
      --tmpdir)
        posix_adapter__flag__tmpdir='1'
        posix_adapter__value__tmpdir="$2"
        shift
        shift
        ;;
      --[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__mktemp' \
          "Unexpected option '${1}'!" \
          'You can only use --extended --silent --invert-match --count -- match-only.'
        ;;
      -[!-]*)
        posix_adapter__report_invalid_parameters \
          'posix_adapter__mktemp' \
          "Invalid single dashed option '${1}'!" \
          "posix_adapter only uses double dashed options like '--option'."
        ;;
      *)
        if [ "$posix_adapter__flag__template" -eq '0' ]
        then
          posix_adapter__flag__template='1'
          posix_adapter__value__template="$1"
          shift
        else
          posix_adapter__report_invalid_parameters \
            'posix_adapter__mktemp' \
            'Unexpected parameter!' \
            "Parameter '${1}' is unexpected!"
        fi
        ;;
    esac
  done

  if [ "$posix_adapter__flag__template" -eq '0' ]
  then
    posix_adapter__report_invalid_parameters \
      'posix_adapter__mktemp' \
      'Missing <template> argument!' \
      'To be able to use grep, you need to specify at least a pattern.'
  fi

  # Assembling the decision string.
  # ,--- directory
  # |,-- tempdir
  # 00
  posix_adapter__decision="${posix_adapter__flag__directory}"
  posix_adapter__decision="${posix_adapter__decision}${posix_adapter__flag__tmpdir}"

  case "$POSIX_ADAPTER__RUNTIME__OS" in

    "$POSIX_ADAPTER__CONSTANT__OS__LINUX")
      _posix_adapter__mktemp__linux \
        "$posix_adapter__decision" \
        "$posix_adapter__value__tmpdir" \
        "$posix_adapter__value__template"
      ;;

    "$POSIX_ADAPTER__CONSTANT__OS__MACOS")
      _posix_adapter__mktemp__darwin \
        "$posix_adapter__decision" \
        "$posix_adapter__value__tmpdir" \
        "$posix_adapter__value__template"
      ;;

    *)
      posix_adapter__report_incompatible_call 'posix_adapter__mktemp'
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
_posix_adapter__mktemp__linux() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__tmpdir="$2"
  posix_adapter__value__template="$3"

  case "$posix_adapter__decision_string" in
  # ,--- directory
  # |,-- tempdir
    00)
      mktemp \
        \
        \
        "$posix_adapter__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    01)
      mktemp \
        \
        --tmpdir="$posix_adapter__value__tmpdir" \
        "$posix_adapter__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    10)
      mktemp \
        --directory \
        \
        "$posix_adapter__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    11)
      mktemp \
        --directory \
        --tmpdir="$posix_adapter__value__tmpdir" \
        "$posix_adapter__value__template" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__mktemp' \
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
_posix_adapter__mktemp__darwin() {
  posix_adapter__decision_string="$1"
  posix_adapter__value__tmpdir="$2"
  posix_adapter__value__template="$3"

  case "$posix_adapter__decision_string" in
  # ,--- directory
  # |,-- tempdir
    00)
      mktemp \
        \
        "$posix_adapter__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    01)
      mktemp \
        \
        "${posix_adapter__value__tmpdir}/${posix_adapter__value__template}" \

      ;;
  # ,--- directory
  # |,-- tempdir
    10)
      mktemp \
        -d \
        "$posix_adapter__value__template" \

      ;;
  # ,--- directory
  # |,-- tempdir
    11)
      mktemp \
        -d \
        "${posix_adapter__value__tmpdir}/${posix_adapter__value__template}" \

      ;;
    *)
      posix_adapter__report_invalid_parameters \
        'posix_adapter__mktemp' \
        'Unexpected parameter combination!' \
        'You can only have (--delimiter --fields) or (--characters).'
      ;;
  esac
}
