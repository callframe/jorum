#!/usr/bin/env bash

## Constants and paths
WORKING_DIR=$(pwd)
CONFIG_DIR="$WORKING_DIR/config"
BUILD_DIR="$WORKING_DIR/build"

HELPERS_SH="$CONFIG_DIR/helpers.sh"
MAKEFILE="$WORKING_DIR/Makefile"

USE_LLVM=1
TARGET_ARCH="x86_64"
SUPPORTED_HOSTS=("linux")
TAB=$'\t'

HOST_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

CC=""
CC_FLAGS=""

## Include scripts
. "$HELPERS_SH" || panic "Could not source helpers.sh"

## Toolchain
sh_is_part "$HOST_OS" "${SUPPORTED_HOSTS[@]}" || panic "Unsupported host OS: $HOST_OS"

CLANG_TC_SH="$CONFIG_DIR/clang-tc.sh"
GCC_TC_SH="$CONFIG_DIR/gcc-tc.sh"
GENERAL_TC_SH="$CONFIG_DIR/general-tc.sh"

if [ "$USE_LLVM" -eq 1 ]; then
    fs_expect_existing "$CLANG_TC_SH"
    . "$CLANG_TC_SH"
else
    fs_expect_existing "$GCC_TC_SH"
    . "$GCC_TC_SH"
fi

fs_expect_existing "$GENERAL_TC_SH"
. "$GENERAL_TC_SH"

sh_defnonempty CC
sh_defined CC_FLAGS

sh_defnonempty LD
sh_defined LD_FLAGS

sh_defnonempty AR
sh_defined AR_FLAGS

sh_defnonempty MKDIR
sh_defined MKDIR_FLAGS

sh_defnonempty ECHO

print "Using toolchain:"
print "  CC: $CC"
print "  LD: $LD"
print "  AR: $AR"
print "  MKDIR: $MKDIR"
print "  ECHO: $ECHO"

## Apply global flags
CC_FLAGS="${CC_FLAGS:+$CC_FLAGS }-ffreestanding -fno-builtin"
LD_FLAGS="${LD_FLAGS:+$LD_FLAGS }-nostdlib"

cat > "$MAKEFILE" << EOF
# Auto-generated Makefile

Q ?= @

## Paths
WORKING_DIR := $WORKING_DIR
BUILD_DIR := $BUILD_DIR

## Toolchain
CC := $CC
CC_FLAGS := $CC_FLAGS

LD := $LD
LD_FLAGS := $LD_FLAGS

AR := $AR
AR_FLAGS := $AR_FLAGS

MKDIR := $MKDIR
MKDIR_FLAGS := $MKDIR_FLAGS

ECHO := $ECHO

define make_dir
${TAB}\$(Q)\$(ECHO) "${TAB}MKDIR \$1"
${TAB}\$(Q)\$(MKDIR) \$(MKDIR_FLAGS) \$1
endef

define compile_c
${TAB}\$(Q)\$(ECHO) "${TAB}CC \$1"
${TAB}\$(Q)\$(CC) \$(CC_FLAGS) -c \$1 -o \$2
endef

define archive_objs
${TAB}\$(Q)\$(ECHO) "${TAB}AR \$2"
${TAB}\$(Q)\$(AR) \$(AR_FLAGS) \$2 \$1
endef

\$(BUILD_DIR):
${TAB}\$(call make_dir,\$(BUILD_DIR))

EOF