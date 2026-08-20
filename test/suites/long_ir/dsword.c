/* Dead WORD spill elision (IR_DEADSTORE width-2 half, IR_DSWORD=0 opts out).
 * A call result committed to its frame slot via store_hl_keep_hl, where the slot
 * is never read back, has the store elided and the value rides HL to its
 * readers. This pins the cases where that is and is NOT allowed:
 *
 *  - dead_result   the plain win: result used once, straight from HL. The slot
 *                  store (and often the whole frame) disappears.
 *  - read_after    the result IS read back after a second call clobbers HL, so
 *                  the slot MUST survive. If elision fired here the reload would
 *                  hit a dropped slot (loud require_slot abort) or read junk.
 *  - via_store     the result is a POINTER used as a store base. Its read is
 *                  cache-served on the first render (so it looks slot-unread),
 *                  but the pointer-store RMW makes the re-lower reload it —
 *                  eliding CREATES the reader. Excluded; this is the shape that
 *                  aborted in storecall.c.
 *  - two_calls     two live call results at once, so at least one genuinely
 *                  needs its slot across the other's call.
 *
 * Self-verifying with explicit constants under 16-bit arithmetic; no printf
 * (it perturbs allocation and can mask exactly this class of bug).
 */
#include "test.h"

static unsigned int g_seq;
static unsigned int mem[4];

static unsigned int step(unsigned int x) { g_seq = (unsigned int)(g_seq + x); return (unsigned int)(x * 3u + 1u); }
static unsigned int *slot_of(unsigned int i)  { return &mem[i & 3u]; }

/* Result used once — the store is dead, the value rides HL. */
static unsigned int dead_result(unsigned int a)
{
    unsigned int r = step(a);
    return r;
}

/* Result read back AFTER another call clobbers HL: the slot must survive. */
static unsigned int read_after(unsigned int a)
{
    unsigned int r = step(a);
    step(a + 1u);                     /* clobbers HL; r must come from its slot */
    return (unsigned int)(r + 7u);
}

/* Call-returned POINTER used as a store base (the storecall.c shape). */
static unsigned int via_store(unsigned int i, unsigned int v)
{
    *slot_of(i) = v;
    return mem[i & 3u];
}

/* Two results live across each other's calls. */
static unsigned int two_calls(unsigned int a)
{
    unsigned int x = step(a);
    unsigned int y = step((unsigned int)(a + 2u));
    return (unsigned int)(x + y);
}

static void test_dsword(void)
{
    g_seq = 0;
    assertEqual(dead_result(5),  16u);      /* 5*3+1 */
    assertEqual(dead_result(0),  1u);

    assertEqual(read_after(5),   23u);      /* 16 + 7, r survived the 2nd call */
    assertEqual(read_after(10),  38u);      /* 31 + 7 */

    mem[0] = mem[1] = mem[2] = mem[3] = 0;
    assertEqual(via_store(1, 0xbeefu), 0xbeefu);
    assertEqual(mem[1], 0xbeefu);           /* the store landed at the right base */
    assertEqual(via_store(6, 0x1234u), 0x1234u);
    assertEqual(mem[2], 0x1234u);

    assertEqual(two_calls(4), 32u);         /* (4*3+1) + (6*3+1) = 13 + 19 */

    assertEqual(g_seq, 47u);                /* every step() ran exactly once */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Dead word-spill elision");
    suite_add_test(test_dsword);
    return suite_run();
}
