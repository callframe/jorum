#pragma once

#include <config.h>

#define GDT_MK_PRESENT(x) ((x) << 0x07)
#define GDT_MK_LONG(x) ((x) << 0x0D)
#define GDT_MK_WIDTH(x) ((x) << 0x0E)
#define GDT_MK_GRAN(x) ((x) << 0x0F)
#define GDT_MK_PRIV(x) (((x) & 0x03) << 0x05)

#define GDT_RX 0x0A
#define GDT_RW 0x02

#define GDT_ACCESS_BITS 8
#define GDT_LIMIT_HI_BITS 4
#define GDT_FLAG_BITS 4

#define GDT_FLAG_AT (GDT_ACCESS_BITS + GDT_LIMIT_HI_BITS)

#define GDT_PRESENT GDT_MK_PRESENT(1)

#if CONFIG_ARCH64
#define GDT_LONG GDT_MK_LONG(1)
#define GDT_WIDTH GDT_MK_WIDTH(0)
#elif CONFIG_ARCH32
#define GDT_LONG GDT_MK_LONG(0)
#define GDT_WIDTH GDT_MK_WIDTH(1)
#else
#error "Unsupported architecture width"
#endif

#define GDT_GRANULARITY GDT_MK_GRAN(1)
#define GDT_PRIV_KERNEL GDT_MK_PRIV(0)
#define GDT_PRIV_USER GDT_MK_PRIV(3)

#define GDT_CODE_COMMON                                                        \
  (GDT_PRESENT | GDT_LONG | GDT_WIDTH | GDT_GRANULARITY | GDT_RX)
#define GDT_DATA_COMMON (GDT_PRESENT | GDT_WIDTH | GDT_GRANULARITY | GDT_RW)

#define GDT_CODE_KERNEL (GDT_CODE_COMMON | GDT_PRIV_KERNEL)
#define GDT_DATA_KERNEL (GDT_DATA_COMMON | GDT_PRIV_KERNEL)
#define GDT_CODE_USER (GDT_CODE_COMMON | GDT_PRIV_USER)
#define GDT_DATA_USER (GDT_DATA_COMMON | GDT_PRIV_USER)

#define GDT_BYTE(x) ((x) & ((1 << GDT_ACCESS_BITS) - 1))
#define GDT_NIBBLE(x) (((x) >> GDT_FLAG_AT) & ((1 << GDT_FLAG_BITS) - 1))
