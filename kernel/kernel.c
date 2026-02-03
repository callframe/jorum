#include "jorum/arch/x86/mm/gdt.h"

void kentry(void) {
  gdt_load(&BSP_GDTR);

  while (1) {
    asm volatile("hlt");
  }
}