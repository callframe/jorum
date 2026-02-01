#!/usr/bin/env bash
#
# config/20_platform.sh
#
# PURPOSE: Platform-specific tools and utilities configuration
# REQUIRES: 00_helpers.sh (sh_command function), TARGET_ARCH variable
# PROVIDES: MKDIR, ECHO, RM, SED, QEMU tool variables
# SIDE EFFECTS: Exits if required tools not found

MKDIR="$(sh_command mkdir)"
MKDIR_FLAGS="-p"

ECHO="$(sh_command echo)"

RM="$(sh_command rm)"
RM_FLAGS="-rf"

SED="$(sh_command sed)"
SED_FLAGS="-e"

QEMU="$(sh_command qemu-system-$TARGET_ARCH)"
QEMU_FLAGS="-M q35 -m 512M -no-reboot -no-shutdown -boot d -d int,cpu_reset"
