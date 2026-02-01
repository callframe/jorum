#!/usr/bin/env bash
#
# configure.sh - Jorum build configuration script
#
# Detects toolchain, generates config.h and toolchain.mk
## Configuration defaults
SUPPORTED_HOSTS=("linux")
SUPPORTED_ARCHS=("x86_64" "i386")
TAB=$'\t'

HOST_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

## Load core utilities and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

. "$CONFIG_DIR/00_helpers.sh" || { echo "PANIC: Could not source 00_helpers.sh" >&2; exit 1; }
sh_source "$CONFIG_DIR/00_paths.sh"

## Load user configuration
sh_source "$JORUM_CONFIG_SH"

## Validate environment
sh_is_part "$HOST_OS" "${SUPPORTED_HOSTS[@]}" || panic "Unsupported host OS: $HOST_OS"
sh_is_part "$TARGET_ARCH" "${SUPPORTED_ARCHS[@]}" || panic "Unsupported target architecture: $TARGET_ARCH"

## Load toolchain configuration
if [ "$USE_LLVM" -eq 1 ]; then
    sh_source "$JORUM_TOOLCHAIN_CLANG"
else
    sh_source "$JORUM_TOOLCHAIN_GCC"
fi

sh_source "$JORUM_PLATFORM_SH"

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

sh_defnonempty GRUB

sh_defnonempty COPY

print "Using toolchain:"
print "  CC: $CC"
print "  LD: $LD"
print "  AR: $AR"
print "  MKDIR: $MKDIR"
print "  ECHO: $ECHO"
print "  RM: $RM"
print "  SED: $SED"
print "  QEMU: $QEMU"
print "  GRUB: $GRUB"
print "  COPY: $COPY"

## Apply global flags
CC_FLAGS="${CC_FLAGS:+$CC_FLAGS }-ffreestanding -fno-builtin -I$JORUM_ROOT"
LD_FLAGS="${LD_FLAGS:+$LD_FLAGS }-nostdlib -no-pie -Wl,--build-id=none"

## Generate header

ARCH32=0
ARCH64=1

if [ "$TARGET_ARCH" = "x86_64" ]; then
    ARCH32=0
    ARCH64=1
fi

sh_subst "$JORUM_CONFIG_IN" "$JORUM_CONFIG_H" \
    $SED_FLAGS "s|@CONFIG_BOOT_STACK@|$BOOT_STACK|g" \
    $SED_FLAGS "s|@CONFIG_BOOT_STACK_ALIGNMENT@|$BOOT_STACK_ALIGNMENT|g" \
    $SED_FLAGS "s|@CONFIG_ARCH32@|$ARCH32|g" \
    $SED_FLAGS "s|@CONFIG_ARCH64@|$ARCH64|g"

## Generate Makefile

if sh_nonempty_bool QEMU; then
    QEMU_MK="QEMU := $QEMU"
    QEMU_FLAGS_MK="QEMU_FLAGS := $QEMU_FLAGS"
fi

cat > "$JORUM_TOOLCHAIN_MK" << EOF
# Auto-generated Makefile by configure.sh
# DO NOT EDIT - Changes will be overwritten

Q ?= @
TARGET_ARCH := $TARGET_ARCH

## Paths
WORKING_DIR := $JORUM_ROOT
BUILD_DIR := $JORUM_BUILD_DIR

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

COPY := $COPY

GRUB := $GRUB

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

define copy_file
${TAB}\$(call notice,COPY ,\$2)
${TAB}\$(Q)\$(COPY) \$1 \$2
endef

EOF
