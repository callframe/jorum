#include "jorum/arch/x86/asm/gdt.h"
#include "jorum/arch/x86/mm/gdt.h"

#define GDT_SIZE 5
static struct gdt_entry BSP_GDT[GDT_SIZE] = {
    GDT_NULL_SEGMENT, GDT_KERNEL_CODE, GDT_KERNEL_DATA, GDT_USER_CODE, GDT_USER_DATA,

};

void kentry(void) {
  struct gdt_ptr gdtr = {
      .limit = sizeof(BSP_GDT) - 1,
      .base = (u64)&BSP_GDT,
  };

  gdt_load(&gdtr);

  while (1) asm volatile("hlt");
}