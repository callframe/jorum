#pragma once

// https://wiki.osdev.org/Global_Descriptor_Table

// GDT Layout
// First 32bits

#define GDT_LIMIT_LOW_START 0
#define GDT_LIMIT_LOW_END 15

#define GDT_BASE_LOW_START 16
#define GDT_BASE_LOW_END 31

// Second 32bits

#define GDT_BASE_MID_START 32
#define GDT_BASE_MID_END 39

#define GDT_ACCESS_START 40
#define GDT_ACCESS_END 47

#define GDT_LIMIT_HIGH_START 48
#define GDT_LIMIT_HIGH_END 51

#define GDT_FLAGS_START 52
#define GDT_FLAGS_END 55

#define GDT_BASE_HIGH_START 56
#define GDT_BASE_HIGH_END 63

// GDT Value Layout
// First 32bits
#define GDT_SOURCE_LIMIT_LOW_START GDT_LIMIT_LOW_START
#define GDT_SOURCE_LIMIT_LOW_END GDT_LIMIT_LOW_END

#define GDT_SOURCE_BASE_LOW_START GDT_BASE_LOW_START
#define GDT_SOURCE_BASE_LOW_END GDT_BASE_LOW_END

// Second 32bits
#define GDT_SOURCE_BASE_MID_START 16
#define GDT_SOURCE_BASE_MID_END 23

#define GDT_SOURCE_ACCESS_START 0
#define GDT_SOURCE_ACCESS_END 7

#define GDT_SOURCE_LIMIT_HIGH_START 16
#define GDT_SOURCE_LIMIT_HIGH_END 19

#define GDT_SOURCE_FLAGS_START 0
#define GDT_SOURCE_FLAGS_END 3

#define GDT_SOURCE_BASE_HIGH_START 24
#define GDT_SOURCE_BASE_HIGH_END 31

// GDT Methods

#define GDT_MASK(start, end) (((1ULL << ((end) - (start) + 1)) - 1) << (start))
#define GDT_SOURCE_MASK(start, end) (((1ULL << ((end) - (start) + 1)) - 1) << (start))

#define GDT_SOURCE_GET(value, start, end) (((value) & GDT_SOURCE_MASK(start, end)) >> (start))
#define GDT_FIELD(src, s_start, s_end, d_start, d_end) \
  (((GDT_SOURCE_GET((src), (s_start), (s_end))) << (d_start)) & GDT_MASK(d_start, d_end))

#define GDT_ENTRY_LIMIT(limit)                                                                                        \
  (GDT_FIELD((limit), GDT_SOURCE_LIMIT_LOW_START, GDT_SOURCE_LIMIT_LOW_END, GDT_LIMIT_LOW_START, GDT_LIMIT_LOW_END) | \
   GDT_FIELD((limit), GDT_SOURCE_LIMIT_HIGH_START, GDT_SOURCE_LIMIT_HIGH_END, GDT_LIMIT_HIGH_START,                   \
             GDT_LIMIT_HIGH_END))

#define GDT_ENTRY_BASE(base)                                                                                     \
  (GDT_FIELD((base), GDT_SOURCE_BASE_LOW_START, GDT_SOURCE_BASE_LOW_END, GDT_BASE_LOW_START, GDT_BASE_LOW_END) | \
   GDT_FIELD((base), GDT_SOURCE_BASE_MID_START, GDT_SOURCE_BASE_MID_END, GDT_BASE_MID_START, GDT_BASE_MID_END) | \
   GDT_FIELD((base), GDT_SOURCE_BASE_HIGH_START, GDT_SOURCE_BASE_HIGH_END, GDT_BASE_HIGH_START, GDT_BASE_HIGH_END))

#define GDT_ENTRY_ACCESS(access) \
  (GDT_FIELD((access), GDT_SOURCE_ACCESS_START, GDT_SOURCE_ACCESS_END, GDT_ACCESS_START, GDT_ACCESS_END))

#define GDT_ENTRY_FLAGS(flags) \
  (GDT_FIELD((flags), GDT_SOURCE_FLAGS_START, GDT_SOURCE_FLAGS_END, GDT_FLAGS_START, GDT_FLAGS_END))

#define GDT_ENTRY(base, limit, access, flags) \
  (GDT_ENTRY_BASE(base) | GDT_ENTRY_LIMIT(limit) | GDT_ENTRY_ACCESS(access) | GDT_ENTRY_FLAGS(flags))

#define GDT_SELECTOR(index, pl) (((index) << 3) | (pl))
