#include <config.h>
#include <jorum/arch/x86/asm/gdt.h>

.global gdt_load
gdt_load:
#if CONFIG_ARCH64
    hlt
    jmp .
#else
#error "gdt_load not implemented for this platform"
#endif