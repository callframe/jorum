#pragma once

// https://wiki.osdev.org/Paging

#define PGG_MASK(bit) (1UL << (bit))

#define PGG_PRESENT PGG_MASK(0)
#define PGG_WRITABLE PGG_MASK(1)
#define PGG_USER PGG_MASK(2)
#define PGG_PWT PGG_MASK(3)
#define PGG_PCD PGG_MASK(4)
#define PGG_ACCESSED PGG_MASK(5)
#define PGG_DIRTY PGG_MASK(6)
#define PGG_PS PGG_MASK(7)
#define PGG_GLOBAL PGG_MASK(8)

#define PGG_PAGE_SHIFT 12
#define PGG_PAGE_SIZE (1UL << PGG_PAGE_SHIFT)
#define PGG_PAGE_MASK (~(PGG_PAGE_SIZE - 1))

#define PGG_HPAGE_SHIFT 21
#define PGG_HPAGE_SIZE (1UL << PGG_HPAGE_SHIFT)
#define PGG_HPAGE_MASK (~(PGG_HPAGE_SIZE - 1))
