/* In-place 32-bit `<<= 1` lowering.
 *
 * gen_shl has a fast path that shifts the four bytes of a spilled long where
 * they sit -- `sla (hl); rl (hl); rl (hl); rl (hl)` up from the LSB -- rather
 * than round-tripping the value through DEHL. Two things gate it, and neither
 * was checked:
 *
 *  - CB shifts. The 8080, 8085 and KR580VM1 have no CB page, so the sequence
 *    is not assemblable and the build fails outright. Those parts belong on
 *    gen_808x_long_const_shift, which the >> lowering already routes to.
 *  - Slot residency. The path rewrites MEMORY, so the slot has to hold the
 *    live value. With the source still cached in DEHL the slot is stale and
 *    the shift lands on whatever the frame reserved -- on the z80 that is the
 *    `push af / push af` prologue, so every input yielded
 *    0x00280028 << 1 = 0x00500050. Silent, and the same on the gbz80.
 *
 * Reaching the stale-slot case needs both halves at once: the value must
 * arrive from memory (so it is DEHL-resident at the shift) AND the function
 * must carry something else that forces a real frame (so the long is also
 * given a slot). A leaf that only loads and shifts keeps the long in
 * registers, never takes the path, and proves nothing -- hence the array,
 * struct and second-long shapes below. Each one produced a different wrong
 * value before the fix, so they are not restating one failure.
 *
 * Expected values are literal constants, not recomputations, so a
 * consistently-wrong lowering cannot agree with itself. Runs on every CPU:
 * only some take the CB path, the rest pin that the shared IR still means
 * the same thing.
 */
#include "test.h"

static unsigned long g_src, g_sink;

/* Array in the frame: the long gets a slot, the value stays cached. */
static unsigned long with_array(void)
{
    unsigned long d;
    unsigned long a[2];
    a[0] = 1UL; a[1] = 2UL;
    d = g_src;
    d <<= 1;
    g_sink = a[0] + a[1];
    return d;
}

/* Same, with the shifted value arriving as a parameter instead. */
static unsigned long with_array_param(unsigned long v)
{
    unsigned long d;
    unsigned long a[3];
    a[0] = 1UL; a[1] = 2UL; a[2] = 3UL;
    d = v;
    d <<= 1;
    g_sink = a[2];
    return d;
}

/* A byte array instead, so the frame layout differs. */
static unsigned long with_bytes(void)
{
    unsigned long d;
    unsigned char b[8];
    unsigned int i;
    for (i = 0; i < 8; i++) b[i] = (unsigned char)i;
    d = g_src;
    d <<= 1;
    g_sink = b[7];
    return d;
}

/* A struct rather than an array. */
static unsigned long with_struct(void)
{
    struct { unsigned long x, y; } s;
    unsigned long d;
    s.x = 1UL; s.y = 2UL;
    d = g_src;
    d <<= 1;
    g_sink = s.x + s.y;
    return d;
}

/* Shifted out of place, as a cross-check that the value itself is sound. */
static unsigned long out_of_place(void)
{
    return g_src << 1;
}

/* The loop that first showed the missing CB gate: a power-of-two walk whose
 * induction variable is the long being shifted. */
static unsigned int pow2_steps(void)
{
    unsigned long d;
    unsigned int n = 0;
    for (d = 1UL; d <= 0x10000UL; d <<= 1) n++;
    return n;
}

void test_long_shl(void)
{
    g_src = 0x12345678UL;
    assertEqual(with_array(), 0x2468ACF0UL);
    assertEqual(g_sink, 3UL);
    assertEqual(with_bytes(), 0x2468ACF0UL);
    assertEqual(with_struct(), 0x2468ACF0UL);
    assertEqual(out_of_place(), 0x2468ACF0UL);

    /* Carry has to cross every byte boundary, and the top bit must drop. */
    g_src = 0x00008000UL;  assertEqual(with_array(), 0x00010000UL);
    g_src = 0x00800000UL;  assertEqual(with_array(), 0x01000000UL);
    g_src = 0x80000000UL;  assertEqual(with_array(), 0x00000000UL);
    g_src = 0xFFFFFFFFUL;  assertEqual(with_array(), 0xFFFFFFFEUL);
    g_src = 0x00000001UL;  assertEqual(with_array(), 0x00000002UL);

    /* 0x00280028 is what the z80 prologue leaves in an unwritten slot, so a
     * shift of the slot rather than the value returned 0x00500050 here. */
    g_src = 0x00280028UL;  assertEqual(with_array(), 0x00500050UL);

    assertEqual(with_array_param(0x12345678UL), 0x2468ACF0UL);
    assertEqual(with_array_param(0xFFFFFFFFUL), 0xFFFFFFFEUL);
    assertEqual(with_array_param(0x00000001UL), 0x00000002UL);

    assertEqual(pow2_steps(), 17u);          /* 1 .. 0x10000 inclusive */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("in-place 32-bit left shift lowering");
    suite_add_test(test_long_shl);
    return suite_run();
}
