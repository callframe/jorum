#include "jorum/arch/x86/asm/gdt.h"

#include <jorum/arch/x86/mm/gdt.h>

static struct gdt_entry BSP_GDT[] = {
    GDT_NULL_SEGMENT,
    GDT_KERNEL_CODE, // << want 
    GDT_KERNEL_DATA, // << want
    GDT_USER_CODE,
    GDT_USER_DATA,
};

struct gdt_ptr BSP_GDTR = {
    .limit = sizeof(BSP_GDT) - 1,
    .base = (u64)&BSP_GDT,
};