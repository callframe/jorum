#include <jorum/arch/x86/asm_gdt.h>

.code64
.section .boot, "ax"
.extern kentry

.global enter_x64
enter_x64:
    mov $GDT_KERNEL_DATA_SELECTOR, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

# Temporarily disabled due to identity mapping missing.
# Debug earlier crash FIRST!!!
#    movabs $kentry, %rax
#    call *%rax

    hlt
    jmp .
