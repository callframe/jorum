ENTRY(_start)

BOOTLOADER_BASE = 1M;
KERNEL_BASE = 0xffff800000000000;

MB_ALIGNMENT = 8;
ALIGNMENT = 0x1000;

P_X = 0x1;
P_W = 0x2;
P_R = 0x4;

PHDRS {
  text PT_LOAD FLAGS(P_R | P_X);
  data PT_LOAD FLAGS(P_R | P_W);
}


SECTIONS {
    . = BOOTLOADER_BASE;

    .multiboot : ALIGN(MB_ALIGNMENT) {
        *(.multiboot)
    } :text

    .boot : ALIGN(ALIGNMENT) {
        *(.boot*)
    } :text

    _bootloader_end = .;
    . = KERNEL_BASE;

    kernel_text_load = _bootloader_end;
    . = ALIGN(ALIGNMENT);
    .text : AT(kernel_text_load) {
        *(.text*)
    } :text

    kernel_rodata_load = kernel_text_load + SIZEOF(.text);
    . = ALIGN(ALIGNMENT);
    .rodata : AT(kernel_rodata_load) {
        *(.rodata*)
    } :text

    kernel_data_load = kernel_rodata_load + SIZEOF(.rodata);
    . = ALIGN(ALIGNMENT);
    .data : AT(kernel_data_load) {
        *(.data*)
    } :data

    kernel_bss_load = kernel_data_load + SIZEOF(.data);

    . = ALIGN(ALIGNMENT);
    .bss : AT(kernel_bss_load) {
        *(.bss*)
        *(COMMON)
    } :data

    /DISCARD/ : {
        *(.eh_frame*)
        *(.note.*)
    }
}
