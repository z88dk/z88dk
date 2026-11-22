/* 8085 sp-relative LONG frame-slot access via the extended load/store ops
 * (`ld hl,(de)` / `ld (de),hl` with `ld de,sp+n`), replacing the 4-byte walk in
 * load_to_dehl_adj / store_dehl. Both halves and both byte orders are at risk:
 *
 *  - The load reads the LOW half first (so it can go to BC, the DEHL cache
 *    invariant) and the HIGH half second, ending `ex de,hl`. Swapping the two
 *    halves, or losing the `ld hl,bc` recovery, gives a value with its words
 *    exchanged — which only shows up if a test value has DIFFERENT halves.
 *  - The store puts the HIGH half out through SHLX, then walks the low half
 *    DOWNWARDS (`dec hl`, `ld (hl),b`, `dec hl`, `ld (hl),c`). An off-by-one on
 *    either `dec hl`, or B and C the wrong way round, corrupts one byte of the
 *    low half or writes outside the slot — so values here have all four bytes
 *    distinct and neighbouring slots are checked afterwards.
 *  - The exit contract is DE = high half, BC = low half. The store recovers DE
 *    with an `ex de,hl` after SHLX; if that were dropped, DE would hold an
 *    ADDRESS and the next cache-served read of the same value would return the
 *    address instead. Reading each long again right after storing it is what
 *    catches that.
 *
 * Enough live longs to force real frame slots (a register pair cannot hold
 * them all), and neighbour longs framing each subject so a stray byte lands in
 * a checked value rather than in padding. Values are literal constants, not
 * recomputations. Runs on every CPU; only the 8085 takes the extended path.
 */
#include "test.h"

static unsigned long g_out[6];
static unsigned long g_in;

/* Six live longs across a call boundary: they cannot all stay in registers, so
 * each one is stored to and reloaded from its own frame slot. The immediate
 * re-read of every value pins the DE = high half exit contract. */
static void sink(unsigned long v) { g_in += v; }

static unsigned long slots(unsigned long seed)
{
    unsigned long a = seed + 0x01020304UL;
    unsigned long b = seed + 0x11223344UL;
    unsigned long c = seed + 0xa1b2c3d4UL;
    unsigned long d = seed + 0x7f800001UL;
    unsigned long e = seed + 0x0000ffffUL;
    unsigned long f = seed + 0xffff0000UL;

    sink(a);                    /* forces the live values out to slots */
    g_out[0] = a; g_out[1] = b; g_out[2] = c;
    sink(b);
    g_out[3] = d; g_out[4] = e; g_out[5] = f;
    sink(c);
    /* Read every one back after the calls: a slot written or read at the wrong
     * offset shows up here, not in the stores above. */
    return (unsigned long)(a ^ b ^ c ^ d ^ e ^ f);
}

/* A long local written, re-read, and written again, with a neighbour long on
 * either side: an off-by-one store lands in a neighbour that is then checked. */
static unsigned long neighbours(unsigned long v)
{
    unsigned long lo = 0x0a0b0c0dUL;
    unsigned long mid = v;
    unsigned long hi = 0x0e0f1011UL;

    sink(mid);
    mid = (unsigned long)(mid + 0x00010001UL);
    sink(hi);
    g_out[0] = lo; g_out[1] = mid; g_out[2] = hi;
    return (unsigned long)(lo + mid + hi);
}

/* Halves deliberately unequal, so an exchanged high/low word is visible. */
static unsigned long halves(unsigned long v)
{
    unsigned long t = v;
    sink(t);
    return (unsigned long)(t + 0UL);
}

void test_lhlx(void)
{
    g_in = 0;

    /* a=0x01020304 b=0x11223344 c=0xa1b2c3d4 d=0x7f800001 e=0x0000ffff
     * f=0xffff0000, xor of all six */
    assertEqual(slots(0UL), 0x31ed0c6aUL);
    assertEqual(g_out[0], 0x01020304UL);
    assertEqual(g_out[3], 0x7f800001UL);
    assertEqual(g_out[4], 0x0000ffffUL);
    assertEqual(g_out[5], 0xffff0000UL);
    /* sink() saw a+b+c */
    assertEqual(g_in, 0xb3d6fa1cUL);

    g_in = 0;
    /* lo + (0x12345678+0x00010001) + hi */
    assertEqual(neighbours(0x12345678UL), 0x2a4f7297UL);
    assertEqual(g_out[0], 0x0a0b0c0dUL);
    assertEqual(g_out[1], 0x12355679UL);
    assertEqual(g_out[2], 0x0e0f1011UL);

    /* unequal halves both ways round */
    assertEqual(halves(0xdead0000UL), 0xdead0000UL);
    assertEqual(halves(0x0000beefUL), 0x0000beefUL);
    assertEqual(halves(0x12345678UL), 0x12345678UL);
    assertEqual(halves(0xffffffffUL), 0xffffffffUL);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 long frame slots via lhlx/shlx");
    suite_add_test(test_lhlx);
    return suite_run();
}
