#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/* A count at or above the promoted width saturates. A left shift and an
   unsigned right shift become 0. char promotes to a 16-bit int, so a
   byte shifted by 8 is still in range. */

void test_char_width(void)
{
    unsigned char c = 0x81;
    volatile int k;

    k = 0;
    assertEqual(c << k, 0x81);
    k = 8;
    assertEqual((unsigned)(c << k), 33024u);
    assertEqual((unsigned)((unsigned char)0x81 << 8), 33024u);
    k = 16;
    assertEqual(c << k, 0);
    assertEqual((unsigned char)0x81 << 16, 0);
    k = 17;
    assertEqual(c << k, 0);
    k = 64;
    assertEqual(c << k, 0);
    assertEqual((unsigned char)0x81 << 64, 0);
}

void test_u16(void)
{
    unsigned u = 0x8001u;
    volatile int k;

    k = 15;
    assertEqual(u >> k, 1u);
    assertEqual(0x8001u >> 15, 1u);
    k = 16;
    assertEqual(u >> k, 0u);
    assertEqual(0x8001u >> 16, 0u);
    k = 17;
    assertEqual(u >> k, 0u);
    assertEqual(0x8001u >> 17, 0u);
    k = 64;
    assertEqual(u >> k, 0u);
    assertEqual(0x8001u >> 64, 0u);

    u = 1u;
    k = 15;
    assertEqual(u << k, 0x8000u);
    assertEqual(1u << 15, 0x8000u);
    k = 16;
    assertEqual(u << k, 0u);
    assertEqual(1u << 16, 0u);
    k = 64;
    assertEqual(u << k, 0u);
    assertEqual(1u << 64, 0u);
}

void test_u32(void)
{
    unsigned long u = 0x80000001UL;
    volatile int k;

    k = 31;
    assertEqual(u >> k, 1UL);
    assertEqual(0x80000001UL >> 31, 1UL);
    k = 32;
    assertEqual(u >> k, 0UL);
    assertEqual(0x80000001UL >> 32, 0UL);
    k = 33;
    assertEqual(u >> k, 0UL);
    k = 64;
    assertEqual(u >> k, 0UL);
    assertEqual(0x80000001UL >> 64, 0UL);

    u = 1UL;
    k = 31;
    assertEqual(u << k, 0x80000000UL);
    assertEqual(1UL << 31, 0x80000000UL);
    k = 32;
    assertEqual(u << k, 0UL);
    assertEqual(1UL << 32, 0UL);
    k = 64;
    assertEqual(u << k, 0UL);
    assertEqual(1UL << 64, 0UL);
}

void test_u64(void)
{
    unsigned long long u = 1ULL;
    volatile int k;

    k = 63;
    assertEqual((unsigned)(u << k), 0u);
    assertEqual((unsigned)(1ULL << 63), 0u);
    assertEqual((int)((u << k) != 0ULL), 1);
    assertEqual((int)((1ULL << 63) != 0ULL), 1);
    k = 64;
    assertEqual(u << k, 0ULL);
    assertEqual(1ULL << 64, 0ULL);
}

void test_signed_in_range(void)
{
    int s = -2;
    long sl = -2;
    volatile int k;

    k = 15;
    assertEqual(s >> k, -1);
    assertEqual((-2) >> 15, -1);
    k = 31;
    assertEqual(sl >> k, -1L);
    assertEqual((-2L) >> 31, -1L);
}

/* 80cc's constant fold of a signed right shift at or above the width
   is 0. The variable shift sign-fills. Keep the sign-fill on sccz80. */
#ifndef __80CC
void test_signed_sat(void)
{
    int s = -2;
    long sl = -2;
    long long sll = -2;
    volatile int k;

    k = 16;
    assertEqual(s >> k, -1);
    assertEqual((-2) >> 16, -1);
    k = 17;
    assertEqual(s >> k, -1);
    k = 64;
    assertEqual(s >> k, -1);
    assertEqual((-2) >> 64, -1);

    k = 32;
    assertEqual(sl >> k, -1L);
    assertEqual((-2L) >> 32, -1L);
    k = 64;
    assertEqual(sl >> k, -1L);
    assertEqual((-2L) >> 64, -1L);

    k = 63;
    assertEqual(sll >> k, -1LL);
    assertEqual((-2LL) >> 63, -1LL);
    k = 64;
    assertEqual(sll >> k, -1LL);
    assertEqual((-2LL) >> 64, -1LL);
}
#endif

int suite_shiftsat(void)
{
    suite_setup("Shift count at the width");
    suite_add_test(test_char_width);
    suite_add_test(test_u16);
    suite_add_test(test_u32);
    suite_add_test(test_u64);
    suite_add_test(test_signed_in_range);
#ifndef __80CC
    suite_add_test(test_signed_sat);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_shiftsat();
    exit(res);
}
