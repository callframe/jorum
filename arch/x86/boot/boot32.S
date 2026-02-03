#include <config.h>
#include <jorum/arch/x86/asm/gdt.h>
#include <jorum/arch/x86/asm/paging.h>
#include <jorum/arch/x86/asm/processor.h>
#include <jorum/arch/x86/asm/multiboot.h>

.code32
.section .multiboot, "a"
multiboot_header:
    .long MULTIBOOT2_HEADER_MAGIC                  # magic number
    .long MULTIBOOT_ARCH_I386                      # architecture
    .long multiboot_header_end - multiboot_header  # header length

    #define MULTIBOOT_LEN (multiboot_header_end - multiboot_header)
    #define MULTIBOOT_PRE_CHECKSUM (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCH_I386 + MULTIBOOT_LEN)
    #define MULTIBOOT_CHECKSUM (-MULTIBOOT_PRE_CHECKSUM)
    .long MULTIBOOT_CHECKSUM                       # checksum

multiboot_end_tag:
    .long MULTIBOOT_TAG_TYPE_END                       # end tag type
    .long (multiboot_end_tag_end - multiboot_end_tag)  # end tag length
multiboot_end_tag_end:
multiboot_header_end:

#if CONFIG_ARCH64
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

    movl $CPUID_QUERY_MAX_EXTENDED, %eax
    cpuid

    cmpl $CPUID_FUNCTION_EXTENDED, %eax
    jb 2f        

    movl $CPUID_FUNCTION_EXTENDED, %eax
    cpuid

    test $CPUID_EFUNC_EDX_LM, %edx
    jnz 1f

3: # no long mode support
    hlt
    jmp .

2: # cpuid does not have extended functions
    jmp 3b

1: # long mode supported
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

    pushl $GDT_KERNEL_CODE_SELECTOR
    pushl $enter_x64
    lret
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

.balign PGG_PAGE_SIZE
boot_pml4:
    .quad boot_pdpt + (PGG_PRESENT | PGG_WRITABLE)
    . = boot_pml4 + (PGG_PML4_INDEX(CONFIG_KERNEL_BASE) * PGG_ENTRY_SIZE)
    .quad boot_pdpt_kernel + (PGG_PRESENT | PGG_WRITABLE)

.balign PGG_PAGE_SIZE
boot_pdpt:
    .quad boot_pd + (PGG_PRESENT | PGG_WRITABLE)

.balign PGG_PAGE_SIZE
boot_pd:
    .quad 0
    .quad _bootloader_start + (PGG_PRESENT | PGG_WRITABLE | PGG_PS)

.balign PGG_PAGE_SIZE
boot_pdpt_kernel:
    . = boot_pdpt_kernel + (PGG_PDPT_INDEX(CONFIG_KERNEL_BASE) * PGG_ENTRY_SIZE)
    .quad boot_pd_kernel + (PGG_PRESENT | PGG_WRITABLE)

.balign PGG_PAGE_SIZE
boot_pd_kernel:
    . = boot_pd_kernel + (PGG_PD_INDEX(CONFIG_KERNEL_BASE) * PGG_ENTRY_SIZE)
    .quad _kernel_start + (PGG_PRESENT | PGG_WRITABLE | PGG_PS)

#endif