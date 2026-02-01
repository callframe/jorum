void kentry(void) {
    while (1) {
        asm volatile("hlt");
    }
}