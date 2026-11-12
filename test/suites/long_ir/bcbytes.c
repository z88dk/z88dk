/* Byte loop counters and temporaries held in B and C across blocks.
 *
 * Each function is written twice, once with ordinary locals and once with
 * volatile ones, which can never take a register home. The two must agree, so
 * the expected values do not depend on the code generator under test.
 */
#include "test.h"

typedef unsigned char u8;

u8 grid[8][16];
u8 gz, gc;                 /* globals read inside loops */
volatile unsigned sink;

/* Nested counters used as indices. */
static unsigned nest_fast(void)
{
    u8 r, c;
    unsigned t = 0;
    for (r = 0; r < 8; ++r)
        for (c = 0; c < 16; ++c) {
            grid[r][c] = (u8)(r * 16 + c);
            t += grid[r][c];
        }
    return t;
}
static unsigned nest_slow(void)
{
    volatile u8 r, c;
    unsigned t = 0;
    for (r = 0; r < 8; ++r)
        for (c = 0; c < 16; ++c) {
            grid[r][c] = (u8)(r * 16 + c);
            t += grid[r][c];
        }
    return t;
}

/* Early exit and continue. */
static unsigned brk_fast(unsigned lim)
{
    u8 i;
    unsigned t = 0;
    for (i = 0; i < 200; ++i) {
        if (i & 1) continue;
        t += i;
        if (t > lim) break;
    }
    return t + i;
}
static unsigned brk_slow(unsigned lim)
{
    volatile u8 i;
    unsigned t = 0;
    for (i = 0; i < 200; ++i) {
        if (i & 1) continue;
        t += i;
        if (t > lim) break;
    }
    return t + i;
}

/* A word parameter next to a byte counter (BC is wanted by both). */
static int word_fast(int x, u8 n)
{
    u8 i;
    int acc = 0;
    for (i = 0; i < n; i++) {
        acc += x * 5;
        acc += (x + i) * 7;
        sink += i;
    }
    return acc;
}
static int word_slow(int x, u8 n)
{
    volatile u8 i;
    int acc = 0;
    for (i = 0; i < n; i++) {
        acc += x * 5;
        acc += (x + i) * 7;
        sink += i;
    }
    return acc;
}

/* A global byte read once inside a loop (it is rematerialised, never held). */
static unsigned remat_fast(u8 n)
{
    u8 i;
    unsigned t = 0;
    for (i = 0; i < n; ++i)
        t += (u8)(gz | gc) ^ i;
    return t;
}
static unsigned remat_slow(u8 n)
{
    volatile u8 i;
    unsigned t = 0;
    for (i = 0; i < n; ++i)
        t += (u8)(gz | gc) ^ i;
    return t;
}

/* A variable-count byte shift borrows B as a counter. */
static unsigned shift_fast(u8 k)
{
    u8 i, v = 1;
    unsigned t = 0;
    for (i = 0; i < 6; ++i) {
        v = (u8)(v << (i & 3));
        t += v + k;
        v = (u8)(v + k);
        v = (u8)(v >> (k & 3));
    }
    return t;
}
static unsigned shift_slow(u8 k)
{
    volatile u8 i, v = 1;
    unsigned t = 0;
    for (i = 0; i < 6; ++i) {
        v = (u8)(v << (i & 3));
        t += v + k;
        v = (u8)(v + k);
        v = (u8)(v >> (k & 3));
    }
    return t;
}

/* A counter set up inside one branch only. */
static unsigned branch_fast(u8 sel)
{
    unsigned t = 0;
    if (sel & 1) {
        u8 i;
        for (i = 0; i < 9; ++i) t += i * 3;
    } else {
        u8 j;
        for (j = 2; j < 11; ++j) t += j;
    }
    return t;
}
static unsigned branch_slow(u8 sel)
{
    unsigned t = 0;
    if (sel & 1) {
        volatile u8 i;
        for (i = 0; i < 9; ++i) t += i * 3;
    } else {
        volatile u8 j;
        for (j = 2; j < 11; ++j) t += j;
    }
    return t;
}

/* Two counters and a word accumulator, the inner bound taken from the outer. */
static unsigned tri_fast(void)
{
    u8 i, j;
    unsigned t = 0;
    for (i = 1; i < 20; ++i)
        for (j = i; j < 30; ++j) {
            if (j & 1) continue;
            t += i * j;
        }
    return t;
}
static unsigned tri_slow(void)
{
    volatile u8 i, j;
    unsigned t = 0;
    for (i = 1; i < 20; ++i)
        for (j = i; j < 30; ++j) {
            if (j & 1) continue;
            t += i * j;
        }
    return t;
}

static void check(void)
{
    int bad = 0;
    unsigned k;

    if (nest_fast() != nest_slow()) ++bad;
    for (k = 0; k < 400; k += 37)
        if (brk_fast(k) != brk_slow(k)) ++bad;
    for (k = 0; k < 20; k += 3) {
        if (word_fast((int)k * 11 - 40, (u8)k) != word_slow((int)k * 11 - 40, (u8)k)) ++bad;
    }
    gz = 0x0C; gc = 0x30;
    for (k = 0; k < 30; k += 4)
        if (remat_fast((u8)k) != remat_slow((u8)k)) ++bad;
    for (k = 0; k < 16; ++k)
        if (shift_fast((u8)k) != shift_slow((u8)k)) ++bad;
    for (k = 0; k < 4; ++k)
        if (branch_fast((u8)k) != branch_slow((u8)k)) ++bad;
    if (tri_fast() != tri_slow()) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte counters in B and C");
    suite_add_test(check);
    return suite_run();
}
