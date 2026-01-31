ENTRY(_start)

BOOTLOADER_BASE = 1M;
KERNEL_BASE = 0xffff800000000000;

SECTIONS {
    . = BOOTLOADER_BASE;

    .boot : ALIGN(4096) {
        *(.boot*)
    }

    . = KERNEL_BASE;

    .text : ALIGN(4096) {
        *(.text*)
    }

    .rodata : ALIGN(4096) {
        *(.rodata*)
    }

    .data : ALIGN(4096) {
        *(.data*)
    }

    .bss : ALIGN(4096) {
        *(.bss*)
        *(COMMON)
    }

    /DISCARD/ : {
        *(.eh_frame*)
    }
}