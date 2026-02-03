void kentry(void) {
  // gdt_load(&BSP_GDTR);

  while (1) {
    asm volatile("hlt");
  }
}