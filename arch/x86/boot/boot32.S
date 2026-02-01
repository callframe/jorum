#include "config.h"

#define MULTIBOOT_MAGIC 0xE85250D6
#define MULTIBOOT_ARCH 0x0

# EAX Extended Processor Signature and Feature Bits.
# https://www.felixcloutier.com/x86/cpuid
#define CPUID_LEAF 0x80000001

# Bit 29: Intel® 64 Architecture available if 1.
# https://www.felixcloutier.com/x86/cpuid
#define CPUID_X64 29

.code32
.section .multiboot
multiboot_header:
    .balign 4
    .long MULTIBOOT_MAGIC          # magic number
    .long MULTIBOOT_ARCH           # architecture
    .long multiboot_header_end - multiboot_header  # header length
    .long 0                        # checksum
multiboot_header_end:


.section .boot, "ax"
#if CONFIG_ARCH64
boot_check_x64:
    movl $CPUID_LEAF, %eax
    cpuid

    bt $CPUID_X64, %edx
    jc .Lx64_supported

    hlt
    jmp .

.Lx64_supported:
    ret


boot_x64:
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
    call boot_check_x64
    call boot_x64
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