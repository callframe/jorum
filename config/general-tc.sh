MKDIR="$(sh_command mkdir)"
MKDIR_FLAGS="-p"

ECHO="$(sh_command echo)"

RM="$(sh_command rm)"
RM_FLAGS="-rf"

SED="$(sh_command sed)"
SED_FLAGS="-e"

QEMU="$(sh_command qemu-system-$TARGET_ARCH)"
QEMU_FLAGS="-M q35 -m 512M -no-reboot -no-shutdown -boot d -d int,cpu_reset"
