/* 8085 word deref through a pointer via LHLX: `ex de,hl` (offset 0) or
 * `ld de,hl+n` (LDHI, folding the field offset) and then `ld hl,(de)`, in place
 * of the offset chain plus the `ld a,(hl+) / ld h,(hl) / ld l,a` byte walk.
 * Three distinct ways this goes wrong:
 *
 *  - The address must reach DE before the load. Reading a field at a NON-ZERO
 *    offset with LDHI and then dereferencing tests that the offset is folded
 *    into the address rather than dropped or applied twice, so the fields here
 *    are at offsets 0, 2 and 4 with values that make a wrong offset visible.
 *  - The load CLOBBERS DE, which the byte walk did not. Values are kept live
 *    across each deref so a wrongly-reused DE corrupts a result instead of
 *    passing unnoticed.
 *  - `ex de,hl / ld hl,(de) / ld de,X` is exactly the window copt's #IR
 *    dead-ex rule used to fold, because it saw HL reloaded and assumed the
 *    swap was dead — but LHLX READS DE, so the swap is the live thing that put
 *    the address there. The indexed-struct loop below reproduces that window
 *    (it is what long_ir's test_cse_array hit); the guard is `%not %2 (de)` in
 *    lib/80cc_rules.1.
 *
 * Expected values are literal constants. Runs on every CPU; only the 8085 takes
 * the LHLX path, and the others pin that the shared IR still means the same.
 */
#include "test.h"

struct rec {
    unsigned int a;      /* offset 0 */
    unsigned int b;      /* offset 2 */
    unsigned int c;      /* offset 4 */
};

static struct rec  one   = { 0x1111u, 0x2222u, 0x3333u };
static struct rec  tab[3];
static unsigned int g_sink;

/* Fields at three offsets through a pointer, all three live at the end so none
 * of the derefs may reuse a register another still needs. */
static unsigned int fields(struct rec *p)
{
    unsigned int x = p->a;
    unsigned int y = p->b;
    unsigned int z = p->c;
    return (unsigned int)(x + y + z);
}

/* A value carried ACROSS a deref: if the deref takes a register `keep` is in
 * without spilling it, the sum comes out wrong. */
static unsigned int carry(struct rec *p, unsigned int keep)
{
    unsigned int t = p->b;
    return (unsigned int)(keep + t + p->c);
}

/* Indexed struct in a loop: the address is recomputed per iteration and the
 * deref window is `ex de,hl / ld hl,(de) / ld de,...` — the copt dead-ex
 * hazard. Two fields per iteration so the second deref runs with the first
 * still live. */
static unsigned int indexed(int k)
{
    int n;
    unsigned int s = 0;
    for (n = 0; n < 3; n++) {
        s = (unsigned int)(s + tab[n].a);
        s = (unsigned int)(s + (unsigned int)(tab[n].b - tab[k].a));
        s = (unsigned int)(s + tab[n].c);
    }
    return s;
}

static void take(unsigned int v);

/* Six deref results all live at once, with calls between them: they cannot
 * stay in registers, so each load is followed immediately by its slot store —
 * `ex de,hl / ld hl,(de) / ld de,sp+N / ld (de),hl`. That middle window is the
 * copt dead-ex hazard: the rule saw HL reloaded and dropped the swap, leaving
 * LHLX reading whatever DE happened to hold. */
static unsigned int spillers(struct rec *p, struct rec *q)
{
    unsigned int a1 = p->a, a2 = p->b, a3 = p->c;
    unsigned int b1 = q->a, b2 = q->b, b3 = q->c;

    take(a1);
    take(b3);
    return (unsigned int)(a1 + a2 + a3 + b1 + b2 + b3);
}

/* Deref feeding a call argument, so the value must survive the call setup. */
static void take(unsigned int v) { g_sink = (unsigned int)(g_sink + v); }

static unsigned int through_call(struct rec *p)
{
    unsigned int held = p->a;
    take(p->b);
    return (unsigned int)(held + p->c);
}

void test_derefw(void)
{
    unsigned int i;

    /* 0x1111 + 0x2222 + 0x3333 */
    assertEqual(fields(&one), 0x6666u);
    /* keep + b + c */
    assertEqual(carry(&one, 0x0001u), 0x5556u);
    assertEqual(carry(&one, 0xf000u), 0x4555u);   /* wraps */

    for (i = 0; i < 3; i++) {
        tab[i].a = (unsigned int)(0x0100u + i);
        tab[i].b = (unsigned int)(0x0200u + i);
        tab[i].c = (unsigned int)(0x0400u + i);
    }
    /* n=0: 0x100 + (0x200-0x100) + 0x400
     * n=1: 0x101 + (0x201-0x100) + 0x401
     * n=2: 0x102 + (0x202-0x100) + 0x402   with k=0 (tab[0].a = 0x100) */
    assertEqual(indexed(0), 0x1209u);
    /* k=2 subtracts 0x102 rather than 0x100 each time: 6 less */
    assertEqual(indexed(2), 0x1203u);

    g_sink = 0;
    /* one = 0x1111+0x2222+0x3333, tab[1] = 0x0101+0x0201+0x0401 */
    assertEqual(spillers(&one, &tab[1]), 0x6d69u);
    assertEqual(g_sink, 0x1512u);       /* a1 = 0x1111, b3 = 0x0401 */

    g_sink = 0;
    assertEqual(through_call(&one), 0x4444u);
    assertEqual(g_sink, 0x2222u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 word deref via lhlx");
    suite_add_test(test_derefw);
    return suite_run();
}
