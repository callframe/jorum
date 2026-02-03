#pragma once

#include <jorum/arch/x86/asm/gdt.h>
#include <jorum/types.h>

struct gdt_entry {
  u64 value;
} PACKED;

struct gdt_ptr {
  u16 limit;
  u64 base;
} PACKED;

void gdt_load(struct gdt_ptr* gdt_ptr);
