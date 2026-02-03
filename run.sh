#!/usr/bin/env bash

export QEMU_FLAGS="-M q35 -m 512M -no-reboot -no-shutdown -boot d -d int,cpu_reset"
qemu-system-x86_64 \
    $QEMU_FLAGS \
    -cdrom jorum.iso
