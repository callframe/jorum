#!/usr/bin/env bash
#
# config/10_toolchain_clang.sh
#
# PURPOSE: LLVM/Clang toolchain configuration
# REQUIRES: 00_helpers.sh (sh_command function)
# PROVIDES: CC, LD, AR toolchain variables with Clang/LLVM binaries
# SIDE EFFECTS: Exits if required tools not found

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