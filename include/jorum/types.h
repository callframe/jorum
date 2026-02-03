#pragma once

#include <config.h>
#include <stdint.h>

#define BYTE_BITS 8

typedef uint8_t u8;

#define U8C(val) ((u8)val)
#define U8_MAX ((u8)~U8C(8))
#define U8_BITS (sizeof(u8) * BYTE_BITS)

typedef uint16_t u16;

#define U16C(val) ((u16)val)
#define U16_MAX ((u16)~U16C(0))
#define U16_BITS (sizeof(u16) * BYTE_BITS)

typedef uint32_t u32;

#define U32C(val) ((u32)val)
#define U32_MAX ((u32)~U32C(0))
#define U32_BITS (sizeof(u32) * BYTE_BITS)

typedef uint64_t u64;

#define U64C(val) ((u64)val)
#define U64_MAX ((u64)~U64C(0))
#define U64_BITS (sizeof(u64) * BYTE_BITS)

typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;

typedef float f32;
typedef double f64;

#if CONFIG_ARCH64
typedef u64 usize;
typedef i64 isize;
#elif CONFIG_ARCH32
typedef u32 usize;
typedef i32 isize;
#else
#error "Unknown architecture bit width"
#endif

#define PACKED __attribute__((packed))
#define LINKIN(name) __attribute__((section(name)))