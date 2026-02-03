#pragma once

// Virtual address structure (48-bit)
// https://wiki.osdev.org/Paging
// https://docs.amd.com/v/u/en-US/40332-PUB_4.08
// 2026-02-02: Figure 5-17 page 579

// Page table entry size
#define PGG_ENTRY_SIZE 8

// Page offset
#define PGG_OFFSET_START 0
#define PGG_OFFSET_END 11

// PT index
#define PGG_PT_START 12
#define PGG_PT_END 20

// PD index
#define PGG_PD_START 21
#define PGG_PD_END 29

// PDPT index
#define PGG_PDPT_START 30
#define PGG_PDPT_END 38

// PML4 index
#define PGG_PML4_START 39
#define PGG_PML4_END 47

// Extract field from virtual address
#define PGG_FIELD_MASK(start, end) (((1ULL << ((end) - (start) + 1)) - 1) << (start))
#define PGG_FIELD_GET(addr, start, end) (((addr) & PGG_FIELD_MASK(start, end)) >> (start))

#define PGG_OFFSET(addr) PGG_FIELD_GET(addr, PGG_OFFSET_START, PGG_OFFSET_END)
#define PGG_PT_INDEX(addr) PGG_FIELD_GET(addr, PGG_PT_START, PGG_PT_END)
#define PGG_PD_INDEX(addr) PGG_FIELD_GET(addr, PGG_PD_START, PGG_PD_END)
#define PGG_PDPT_INDEX(addr) PGG_FIELD_GET(addr, PGG_PDPT_START, PGG_PDPT_END)
#define PGG_PML4_INDEX(addr) PGG_FIELD_GET(addr, PGG_PML4_START, PGG_PML4_END)
