clang_target() {
    local vendor="unknown"
    local os="none"
    echo "$TARGET_ARCH-$vendor-$os"
}

CC=$(sh_command clang)
CC_FLAGS="--target=$(clang_target)"

LD=$(sh_command clang)
LD_FLAGS=""

AR=$(sh_command llvm-ar)
AR_FLAGS="rcs"