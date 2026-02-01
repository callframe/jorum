#!/usr/bin/env bash
#
# config/00_helpers.sh
#
# PURPOSE: Core shell utility functions for configure system
# REQUIRES: (none - load first)
# PROVIDES: print, panic, sh_*, fs_* functions
# SIDE EFFECTS: Functions like panic() will exit the script

print() {
    echo "$*"
}

stderr() {
    print "$*" >&2
}

panic() {
    stderr "PANIC: $*"
    exit 1
}

unimplemented(){
   stderr "Unimplemented in ${BASH_SOURCE[1]} at line ${BASH_LINENO[0]}:"
   panic "$1"
}

fs_does_exist(){
    [ -e "$1" ]
}

fs_expect_existing() {
    fs_does_exist "$1" || panic "Expected existing file: $1"
}

sh_source() {
    local file="$1"
    # shellcheck disable=SC1090
    . "$file" || panic "Failed to source: $file"
}

sh_nonempty_bool() {
    local var="$1"
    [ -n "${!var}" ]
}

sh_nonempty() {
    local var="$1"
    sh_nonempty_bool "$var" || panic "Variable '$var' must not be empty"
}

sh_defined_bool() {
    local var="$1"
    [ -n "${!var+x}" ]
}

sh_defined() {
   local var="$1"
   sh_defined_bool "$var" || panic "Variable '$var' is not defined"
}

sh_defnonempty() {
    local var="$1"
    sh_defined "$var"
    sh_nonempty "$var"
}

sh_command() {
    command -v "$1" || panic "Command '$1' not found"
}

sh_is_part() {
    local item="$1"
    shift

    for element in "$@"; do
        if [ "$element" = "$item" ]; then
            return 0
        fi
    done

    return 1
}

sh_subst() {
    local in="$1"
    local out="$2"
    shift 2

    "$SED" "$@" "$in" > "$out" \
        || panic "sed substitution failed"
}
