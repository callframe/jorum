#include <jorum/arch/x86/asm_gdt.h>

.code64
.section .boot, "ax"
enter_x64:
    mov $GDT_KERNEL_DATA_SELECTOR, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss


    hlt
    jmp .