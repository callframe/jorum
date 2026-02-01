#!/usr/bin/env bash
#
# config/00_paths.sh
#
# PURPOSE: Centralized path definitions for the Jorum project
# REQUIRES: (none - load first)
# PROVIDES: JORUM_* path variables
# SIDE EFFECTS: None

# Project root (absolute path, derived from this file's location)
JORUM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source directories
JORUM_CONFIG_DIR="$JORUM_ROOT/config"
JORUM_ARCH_DIR="$JORUM_ROOT/arch"

# Build artifacts
JORUM_BUILD_DIR="$JORUM_ROOT/build"

# Generated files
JORUM_CONFIG_H="$JORUM_ROOT/config.h"
JORUM_TOOLCHAIN_MK="$JORUM_ROOT/toolchain.mk"
JORUM_BINARY="$JORUM_ROOT/jorum"

# Config files
JORUM_CONFIG_SH="$JORUM_ROOT/config.sh"
JORUM_CONFIG_IN="$JORUM_CONFIG_DIR/config.in"

# Helper scripts (will be renamed in restructure)
JORUM_HELPERS_SH="$JORUM_CONFIG_DIR/00_helpers.sh"
JORUM_TOOLCHAIN_CLANG="$JORUM_CONFIG_DIR/10_toolchain_clang.sh"
JORUM_TOOLCHAIN_GCC="$JORUM_CONFIG_DIR/10_toolchain_gcc.sh"
JORUM_PLATFORM_SH="$JORUM_CONFIG_DIR/20_platform.sh"
