#include <config.h>
#include <jorum/arch/x86/asm_gdt.h>
#include <jorum/arch/x86/asm_paging.h>
#include <jorum/arch/x86/asm_processor.h>

#define ASM_FILE
#include <jorum/multiboot.h>

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

.code32
.section .multiboot, "a"
multiboot_header:
    .balign MULTIBOOT_ALIGNMENT
    .long MULTIBOOT2_HEADER_MAGIC          # magic number
    .long MULTIBOOT_ARCH           # architecture
    .long multiboot_header_end - multiboot_header  # header length

    #define MULTIBOOT_LEN (multiboot_header_end - multiboot_header)
    #define MULTIBOOT_PRE_CHECKSUM (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCH + MULTIBOOT_LEN)
    #define MULTIBOOT_CHECKSUM (-MULTIBOOT_PRE_CHECKSUM)
    .long MULTIBOOT_CHECKSUM     # checksum

    .balign MULTIBOOT_ALIGNMENT
    .long MULTIBOOT_END_TAG_TYPE      # end tag type
    .long MULTIBOOT_END_TAG_SIZE      # end tag size
multiboot_header_end:

#if CONFIG_ARCH64
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

#endif

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
    # load GDT
    lgdt boot_gdtr

    # enable PAE
    movl %cr4, %eax
    orl $CR4_PAE, %eax
    movl %eax, %cr4

    # load PML4
    lea boot_pml4, %eax
    movl %eax, %cr3

    # enable long mode
    movl $MSR_EFER, %ecx
    rdmsr
    orl $EFER_LME, %eax
    wrmsr

    # enable paging
    movl %cr0, %eax
    orl $CR0_PG, %eax
    movl %eax, %cr0

    # far jump 
    ljmp $GDT_KERNEL_CODE_SELECTOR, $enter_x64
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
    call kentry
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

#if CONFIG_ARCH64
.section .boot.paging, "ax"

.extern _kernel_start
.extern _kernel_end

boot_pml4:
    .quad boot_pdpt + (PGG_PRESENT | PGG_WRITABLE)

boot_pdpt:
    .quad boot_pd + (PGG_PRESENT | PGG_WRITABLE)

boot_pd:
    .quad _kernel_start + (PGG_PRESENT | PGG_WRITABLE | PGG_PAGE_SIZE)

#endif