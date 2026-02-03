#include <config.h>
#include <jorum/arch/x86/asm/gdt.h>

.global gdt_load
gdt_load:
#if CONFIG_ARCH64
    lgdt (%rdi)

    pushq $GDT_KERNEL_CODE_SELECTOR
    lea 1f(%rip), %rax
    pushq %rax
    lretq
1:
    movw $GDT_KERNEL_DATA_SELECTOR, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    ret
#else
#error "gdt_load not implemented for this platform"
#endif