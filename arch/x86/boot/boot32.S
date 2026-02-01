#include <config.h>
#include <jorum/arch/x86/asm_gdt.h>

#define MULTIBOOT_MAGIC 0xE85250D6
#define MULTIBOOT_ARCH 0x0
#define MULTIBOOT_ALIGNMENT 8

#define MULTIBOOT_END_TAG_TYPE 0
#define MULTIBOOT_END_TAG_SIZE 8

# EAX Extended Processor Signature and Feature Bits.
# https://www.felixcloutier.com/x86/cpuid
#define CPUID_LEAF 0x80000000
#define CPUID_LEAF_1 0x80000001

# Bit 29: Intel® 64 Architecture available if 1.
# https://www.felixcloutier.com/x86/cpuid
#define CPUID_X64 29
.code64
.section .boot.rodata, "a"
boot_gdt_start:
boot_gdt:
    .quad GDT_NULL_SEGMENT
    .quad GDT_KERNEL_CODE
    .quad GDT_KERNEL_DATA
    .quad GDT_USER_CODE
    .quad GDT_USER_DATA
boot_gdt_end:

boot_gdtr:
    .word boot_gdt_end - boot_gdt - 1  # limit
    .long boot_gdt                     # base


.code32
.section .multiboot, "a"
multiboot_header:
    .balign MULTIBOOT_ALIGNMENT
    .long MULTIBOOT_MAGIC          # magic number
    .long MULTIBOOT_ARCH           # architecture
    .long multiboot_header_end - multiboot_header  # header length

    #define MULTIBOOT_LEN (multiboot_header_end - multiboot_header)
    #define MULTIBOOT_CHECKSUM (-(MULTIBOOT_MAGIC + MULTIBOOT_ARCH + MULTIBOOT_LEN))
    .long MULTIBOOT_CHECKSUM     # checksum

    .balign MULTIBOOT_ALIGNMENT
    .long MULTIBOOT_END_TAG_TYPE      # end tag type
    .long MULTIBOOT_END_TAG_SIZE      # end tag size
multiboot_header_end:


.section .boot, "ax"
.extern enter_x64

#if CONFIG_ARCH64
boot_x64_check:

    movl $CPUID_LEAF, %eax
    cpuid

    cmpl $CPUID_LEAF_1, %eax
    jb 2f        

    movl $CPUID_LEAF_1, %eax
    cpuid

    bt $CPUID_X64, %edx
    jc 1f          # x64 supported

3: # not x64
    hlt
    jmp .

2: # cpuid leaf not supported
    jmp 3b

1: # x64 supported
    ret

boot_x64:
    lgdt boot_gdtr

    hlt
    jmp .

#elif CONFIG_ARCH32

boot_x86:
    lgdt boot_gdtr
    ljmp $GDT_KERNEL_CODE_SELECTOR, $x86_enter

x86_enter:
    mov $GDT_KERNEL_DATA_SELECTOR, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    ret


#endif

.global _start
_start:
    # disable interrupts
    cli

    # safe multiboot
    movl %eax, mb_magic
    movl %ebx, mb_ptr

    # setup stack
    lea stack_top, %esp
    movl %esp, %ebp

#if CONFIG_ARCH64
    call boot_x64_check
    call boot_x64

#elif CONFIG_ARCH32
    call boot_x86
#endif

    hlt
    jmp .

.section .boot.bss, "aw", @nobits
.balign CONFIG_BOOT_STACK_ALIGNMENT
stack: .space CONFIG_BOOT_STACK
stack_top:

.global mb_ptr
mb_ptr: .long 0
.global mb_magic
mb_magic: .long 0