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

sh_nonempty() {
    local var="$1"
    [ -n "${!var}" ] || panic "Variable '$var' must not be empty"
}

sh_command() {
    command -v "$1" || panic "Command '$1' not found"
}
