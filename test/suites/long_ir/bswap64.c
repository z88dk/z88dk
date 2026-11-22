/* __builtin_bswap64 reverses the eight bytes of a long long, and
 * intrinsic_swap_word_32 exchanges the halves of a long. */
#include "test.h"
#include <intrinsic.h>

typedef unsigned long long u64;
typedef unsigned long u32;

static u64 g64;
static volatile int sink;

static u64 bs64(u64 x)                 { return __builtin_bswap64(x); }
static u64 bs64_twice(u64 x)           { return __builtin_bswap64(__builtin_bswap64(x)); }
static u64 bs64_from32(u32 x)          { return __builtin_bswap64(x); }
static u64 bs64_glob(void)             { return __builtin_bswap64(g64); }
static u64 bs64_live(u64 x, u64 y)     { u64 a = __builtin_bswap64(x); sink++; return a ^ y; }
static u32 sw(u32 x)                   { return intrinsic_swap_word_32(x); }
static u32 sw_twice(u32 x)             { return intrinsic_swap_word_32(intrinsic_swap_word_32(x)); }
static u32 sw_hi(u32 x)                { return intrinsic_swap_word_32(x) >> 16; }
static u32 sw_add(u32 x, u32 y)        { return intrinsic_swap_word_32(x) + y; }

static void test_bswap64(void)
{
    assertEqual(bs64(0x0102030405060708ULL) == 0x0807060504030201ULL, 1);
    assertEqual(bs64(0x00000000000000FFULL) == 0xFF00000000000000ULL, 1);
    assertEqual(bs64(0xFF00000000000000ULL) == 0x00000000000000FFULL, 1);
    assertEqual(bs64_twice(0x1122334455667788ULL) == 0x1122334455667788ULL, 1);
    assertEqual(bs64_from32(0x11223344UL) == 0x4433221100000000ULL, 1);
    g64 = 0xA1B2C3D4E5F60718ULL;
    assertEqual(bs64_glob() == 0x1807F6E5D4C3B2A1ULL, 1);
    assertEqual(bs64_live(0x0102030405060708ULL, 0xFFULL) == (0x0807060504030201ULL ^ 0xFFULL), 1);
    assertEqual(sw(0x11223344UL) == 0x33441122UL, 1);
    assertEqual(sw_twice(0x11223344UL) == 0x11223344UL, 1);
    assertEqual(sw_hi(0x11223344UL) == 0x3344UL, 1);
    assertEqual(sw_add(0x00010002UL, 1UL) == 0x00020002UL, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bswap64 and swap_word_32");
    suite_add_test(test_bswap64);
    return suite_run();
}
