/*
 * lshiftbench.c — 32-bit shifts: a loop-carried long and constant counts.
 *
 * crcbench shifts a long RIGHT by 1 in an unrolled body; the value there is
 * only ever transient. This bench covers the other half of what real code does
 * with a long:
 *
 *   crc16     a bit-serial CRC-16 (CCITT): `x <<= 1; if (x & 0x01000000)
 *             x ^= poly` in a counted loop, so the long has to survive the back
 *             edge, followed by `(x & 0x00ffff00) >> 8`
 *   kshift    constant counts on an unsigned long: the byte-multiple counts
 *             (8, 16, 24), which are byte moves, and the small counts (1, 3,
 *             5), which are a few rotate steps
 *   ksshift   the same on a signed long, where the sign must propagate
 *   pack      serialisation: four bytes packed into a long and unpacked again
 *
 * All values are 32-bit by construction (u32/s32), so the checksum is identical
 * on the 16-bit-int target and the verifying host.
 */
#include <stdlib.h>
#ifdef HOST_VERIFY
#include <stdint.h>
typedef uint32_t u32;
typedef int32_t  s32;
#else
#include "test.h"
typedef unsigned long u32;
typedef long          s32;
#endif

#define BUF_LEN 128
#define ROUNDS  64
#define CHK     14619u       /* host-verified; see lshiftbench_compute() */

static unsigned char buffer[BUF_LEN];

static unsigned int crc16_update(unsigned int crc, unsigned char c)
{
    u32 x;
    unsigned int i;

    x = ((u32)crc << 8) + c;
    for (i = 0; i < 8; i++) {
        x = x << 1;
        if (x & 0x01000000UL)
            x = x ^ 0x01102100UL;
    }
    return (unsigned int)((x & 0x00ffff00UL) >> 8);
}

static u32 kshift(u32 v)
{
    u32 a;

    a  = (v >> 8) & 0xffffffffUL;
    a ^= (v >> 16);
    a ^= (v >> 24);
    a ^= (v << 8)  & 0xffffffffUL;
    a ^= (v << 16) & 0xffffffffUL;
    a ^= (v << 24) & 0xffffffffUL;
    a ^= (v >> 1);
    a ^= (v << 1)  & 0xffffffffUL;
    a ^= (v << 3)  & 0xffffffffUL;
    a ^= (v >> 5);
    return a;
}

static u32 ksshift(u32 v)
{
    s32 s = (s32)v;
    u32 a;

    a  = (u32)(s >> 8);
    a ^= (u32)(s >> 16);
    a ^= (u32)(s >> 24);
    a ^= (u32)(s >> 31);
    a ^= (u32)(s >> 7);
    return a;
}

static u32 pack(u32 v)
{
    unsigned char b0 = (unsigned char)v;
    unsigned char b1 = (unsigned char)(v >> 8);
    unsigned char b2 = (unsigned char)(v >> 16);
    unsigned char b3 = (unsigned char)(v >> 24);

    return (((u32)b0 << 24) | ((u32)b1 << 16) | ((u32)b2 << 8) | b3)
           & 0xffffffffUL;
}

static unsigned int lshiftbench_compute(void)
{
    unsigned int i, r;
    unsigned int seed = 0xC001u;
    unsigned int crc = 0xffffu;
    u32 v = 0x12345679UL, chk = 0;

    for (i = 0; i < BUF_LEN; i++) {
        buffer[i] = (unsigned char)(seed & 0xffu);
        seed = (unsigned int)(seed * 25173u + 13849u);
    }
    for (r = 0; r < ROUNDS; r++) {
        for (i = 0; i < BUF_LEN; i++)
            crc = crc16_update(crc, buffer[i]);
        v = (v * 1664525UL + 1013904223UL) & 0xffffffffUL;
        chk ^= kshift(v);
        chk ^= ksshift(v + r);
        chk ^= pack(v);
    }
    return (unsigned int)((chk ^ (chk >> 16) ^ crc) & 0xffffu);
}

#ifndef HOST_VERIFY
static void lshift_run(void)
{
    unsigned int chk = lshiftbench_compute();
    Assert(chk == CHK, "long shift checksum (host-verified)");
}

int suite_lshift(void)
{
    suite_setup("Long Shift Tests");
    suite_add_test(lshift_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_lshift();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", lshiftbench_compute()); return 0; }
#endif
