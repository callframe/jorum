#!/usr/bin/env bash

## Constants and paths
WORKING=$(pwd)
CONFIG_DIR="$WORKING/config"
HELPERS_SH="$CONFIG_DIR/helpers.sh"

USE_LLVM=1
TARGET_ARCH="x86_64"

CC=""
CC_FLAGS=""

## Include scripts
. "$HELPERS_SH" || panic "Could not source helpers.sh"

## Toolchain
CLANG_TC_SH="$CONFIG_DIR/clang-tc.sh"
GCC_TC_SH="$CONFIG_DIR/gcc-tc.sh"

if [ "$USE_LLVM" -eq 1 ]; then
    fs_expect_existing "$CLANG_TC_SH"
    . "$CLANG_TC_SH"
else
    fs_expect_existing "$GCC_TC_SH"
    . "$GCC_TC_SH"
fi

print "Using toolchain:"
print "  CC: $CC"
print "  LD: $LD"

## Validate toolchain
sh_nonempty CC
sh_nonempty LD

## Apply global flags
CC_FLAGS="$CC_FLAGS -ffreestanding -fno-builtin"
LD_FLAGS="$LD_FLAGS -nostdlib"

