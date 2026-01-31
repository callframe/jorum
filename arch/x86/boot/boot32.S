#include "config.h"

#define MULTIBOOT_MAGIC 0xE85250D6
#define MULTIBOOT_ARCH 0x0

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
    
.halt:
    jmp .

.section .boot.bss, "aw", @nobits
.balign BOOT_STACK_ALIGNMENT
stack: .space BOOT_STACK
stack_top:

mb_ptr: .long 0
mb_magic: .long 0