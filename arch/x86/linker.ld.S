#include <config.h>

ENTRY(_start)

BOOTLOADER_BASE = 2M;
KERNEL_BASE = CONFIG_KERNEL_BASE;

MB_ALIGNMENT = 8;
ALIGNMENT = 0x1000;

P_X = 0x1;
P_W = 0x2;
P_R = 0x4;

PHDRS {
  boot   PT_LOAD FLAGS(P_R | P_X);
  ktext  PT_LOAD FLAGS(P_R | P_X);
  kdata  PT_LOAD FLAGS(P_R | P_W);
}

SECTIONS {
    . = BOOTLOADER_BASE;
    _bootloader_start = .;

    .multiboot : ALIGN(MB_ALIGNMENT) {
        *(.multiboot)
    } :boot

    .boot : ALIGN(ALIGNMENT) {
        *(.boot*)
    } :boot

    _bootloader_end = .;

    /* ================= kernel higher half ================= */
    _kernel_start = ALIGN(_bootloader_end, 2M);
    . = KERNEL_BASE;

    _kphys_offset = _kernel_start - KERNEL_BASE;

    .text : AT(ADDR(.text) + _kphys_offset) {
        *(.text*)
    } :ktext

    .rodata : AT(ADDR(.rodata) + _kphys_offset) {
        *(.rodata*)
    } :ktext

    .data : AT(ADDR(.data) + _kphys_offset) {
        *(.data*)
    } :kdata

    .bss : AT(ADDR(.bss) + _kphys_offset) {
        *(.bss*)
        *(COMMON)
    } :kdata

    /DISCARD/ : {
        *(.eh_frame*)
        *(.note.*)
    }
}
