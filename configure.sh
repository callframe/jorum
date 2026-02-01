#!/usr/bin/env bash

## Constants and paths
WORKING_DIR=$(pwd)
CONFIG_DIR="$WORKING_DIR/config"
BUILD_DIR="$WORKING_DIR/build"

HELPERS_SH="$CONFIG_DIR/helpers.sh"
MAKEFILE="$WORKING_DIR/toolchain.mk"

CONFIG_SH="$WORKING_DIR/config.sh"
CONFIG_IN="$CONFIG_DIR/config.in"
CONFIG_OUT="$WORKING_DIR/config.h"

USE_LLVM=1
TARGET_ARCH="x86_64"
SUPPORTED_HOSTS=("linux")
SUPPORTED_ARCHS=("x86_64")
TAB=$'\t'

HOST_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

## Include scripts
. "$HELPERS_SH" || panic "Could not source helpers.sh"

fs_expect_existing "$CONFIG_SH"
. "$CONFIG_SH"

## Toolchain
sh_is_part "$HOST_OS" "${SUPPORTED_HOSTS[@]}" || panic "Unsupported host OS: $HOST_OS"
sh_is_part "$TARGET_ARCH" "${SUPPORTED_ARCHS[@]}" || panic "Unsupported target architecture: $TARGET_ARCH"

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

sh_defnonempty RM
sh_defined RM_FLAGS

sh_defnonempty SED
sh_defined SED_FLAGS

sh_defined QEMU
sh_defined QEMU_FLAGS

print "Using toolchain:"
print "  CC: $CC"
print "  LD: $LD"
print "  AR: $AR"
print "  MKDIR: $MKDIR"
print "  ECHO: $ECHO"
print "  RM: $RM"
print "  SED: $SED"
print "  QEMU: $QEMU"

## Apply global flags
CC_FLAGS="${CC_FLAGS:+$CC_FLAGS }-ffreestanding -fno-builtin -I$WORKING_DIR"
LD_FLAGS="${LD_FLAGS:+$LD_FLAGS }-nostdlib -no-pie -Wl,--build-id=none"

## Generate header

ARCH32=0
ARCH64=1

if [ "$TARGET_ARCH" = "x86_64" ]; then
    ARCH32=0
    ARCH64=1
fi

sh_subst "$CONFIG_IN" "$CONFIG_OUT" \
    $SED_FLAGS "s|@CONFIG_BOOT_STACK@|$BOOT_STACK|g" \
    $SED_FLAGS "s|@CONFIG_BOOT_STACK_ALIGNMENT@|$BOOT_STACK_ALIGNMENT|g" \
    $SED_FLAGS "s|@CONFIG_ARCH32@|$ARCH32|g" \
    $SED_FLAGS "s|@CONFIG_ARCH64@|$ARCH64|g"

## Generate Makefile

if sh_nonempty_bool QEMU; then
    QEMU_MK="QEMU := $QEMU"
    QEMU_FLAGS_MK="QEMU_FLAGS := $QEMU_FLAGS"
fi

cat > "$MAKEFILE" << EOF
# Auto-generated Makefile

Q ?= @
TARGET_ARCH := $TARGET_ARCH

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

RM := $RM
RM_FLAGS := $RM_FLAGS

${QEMU_MK}
${QEMU_FLAGS_MK}

## Methods

define notice
${TAB}\$(Q)\$(ECHO) "  \$1\$(notdir \$2)"
endef

define make_dir
${TAB}\$(call notice,MKDIR ,\$1)
${TAB}\$(Q)\$(MKDIR) \$(MKDIR_FLAGS) \$1
endef

define compile_c
${TAB}\$(call notice,CC ,\$1)
${TAB}\$(Q)\$(CC) \$(CC_FLAGS) -c \$1 -o \$2
endef

define archive_objs
${TAB}\$(call notice,AR ,\$2)
${TAB}\$(Q)\$(AR) \$(AR_FLAGS) \$2 \$1
endef

define link_objs
${TAB}\$(call notice,LD ,\$2)
${TAB}\$(Q)\$(LD) \$(LD_FLAGS) \$1 -o \$2
endef

define remove_at
${TAB}\$(call notice,RM ,\$1)
${TAB}\$(Q)\$(RM) \$(RM_FLAGS) \$1
endef

define c2objs
${TAB}\$(patsubst %.c,%.o,\$(filter %.c,\$1))
endef

define asm2objs
${TAB}\$(patsubst %.S,%.o,\$(filter %.S,\$1))
endef

EOF