ENTRY(_start)

BOOTLOADER_BASE = 1M;
KERNEL_BASE = 0xffff800000000000;

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

    .multiboot : ALIGN(MB_ALIGNMENT) {
        *(.multiboot)
    } :boot

    .boot : ALIGN(ALIGNMENT) {
        *(.boot*)
    } :boot

    _bootloader_end = .;

    /* ================= kernel higher half ================= */

    . = KERNEL_BASE;

    kernel_text_load = _bootloader_end;

    .text : AT(kernel_text_load) {
        *(.text*)
    } :ktext

    kernel_rodata_load = kernel_text_load + SIZEOF(.text);

    .rodata : AT(kernel_rodata_load) {
        *(.rodata*)
    } :ktext

    kernel_data_load = kernel_rodata_load + SIZEOF(.rodata);

    .data : AT(kernel_data_load) {
        *(.data*)
    } :kdata

    kernel_bss_load = kernel_data_load + SIZEOF(.data);

    .bss : AT(kernel_bss_load) {
        *(.bss*)
        *(COMMON)
    } :kdata

    /DISCARD/ : {
        *(.eh_frame*)
        *(.note.*)
    }
}
