clang_target() {
    local vendor="unknown"
    local os="none"
    echo "$TARGET_ARCH-$vendor-$os"
}

CC=$(sh_command clang)
CC_FLAGS="--target=$(clang_target)"

LD=$(sh_command ld.lld)
LD_FLAGS=""