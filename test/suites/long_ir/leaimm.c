/* gen_lea emits nothing when lea_all_uses_indexed() says every use of the
 * address became a frame-indexed access. That predicate has to agree with what
 * gen_st_mem actually does, and it did not: gen_st_mem's frame-indexed store
 * path is guarded on `src[0] >= 0`, so a store whose VALUE is a folded immediate
 * skips it and materialises the base with `load_to_hl(mem.base)` instead. The
 * predicate never looked at src[0], so it counted such a store as indexed, the
 * LEA was elided, and the store then read an address that was never produced.
 *
 * How it stayed hidden: the LEA was ALSO rematerialisable (a frame-slot address
 * recomputed on demand), so the read recomputed it and the answer came out
 * right. It only became visible when the address was NOT rematerialisable —
 * ir_stack_spill parks it (IR_PR_STACK, push at the def / pop at the use), which
 * makes remat-LEA correctly decline, and then the def emitted no push while the
 * use had no slot to read: a hard abort, "value read with no live register and no
 * stack slot". That is z80/z80n/z180 in fp mode, where word slots are dear enough
 * for the park to pay; localbench's record() was the corpus case.
 *
 * A silent wrong answer was never reachable, and the reason is worth keeping: the
 * predicate returns 0 the moment the function contains ANY call, and remat-LEA is
 * gated to call-free functions — so the only functions that can elide a LEA are
 * exactly the ones where remat covers the read.
 *
 * The shape needed is therefore all of: a call-free function, a frame-resident
 * struct addressed through one LEA, enough live values that the address gets
 * parked rather than kept in a register, and a folded-immediate store among the
 * uses. `d = 0` below is that store; the other fields keep the LEA's uses varied
 * so the predicate has something to say yes to.
 */
#include "test.h"

struct rec { int a; int b; int c; int d; };

static unsigned int g_seen;

/* The reproducer: three computed field stores then a CONSTANT one. Call-free, so
 * remat-LEA applies and the park is possible. */
static int record(int seed)
{
    struct rec r;
    int i;

    r.a = seed & 255;
    r.b = (seed >> 4) & 255;
    r.c = (seed >> 8) & 255;
    r.d = 0;                       /* folded immediate stored through the LEA */

    for (i = 0; i < 4; i++) {
        r.d = (r.d + r.a) & 4095;
        r.a = (r.a ^ r.b) & 255;
        r.b = (r.b + r.c) & 255;
    }
    return r.a + r.b * 2 + r.c * 4 + r.d * 8;
}

/* Constant store FIRST, so the elided address is read before anything else has
 * had a chance to leave it in a register. */
static int zero_first(int seed)
{
    struct rec r;

    r.d = 0;
    r.a = seed & 127;
    r.b = 0;
    r.c = (seed >> 3) & 127;
    return r.a + r.b + r.c * 2 + r.d;
}

/* Every field a folded immediate: nothing computes an address for free. */
static int all_const(void)
{
    struct rec r;

    r.a = 1;
    r.b = 2;
    r.c = 3;
    r.d = 4;
    return r.a + r.b * 2 + r.c * 4 + r.d * 8;
}

/* Byte-wide members: the byte store has its own indexed path (frame_ix_disp),
 * guarded the same way, so a folded-immediate BYTE store is the same hazard. */
struct brec { unsigned char p; unsigned char q; unsigned int w; };

static unsigned int bytes_const(unsigned int seed)
{
    struct brec b;

    b.p = (unsigned char)(seed & 15u);
    b.q = 0;                        /* folded immediate, byte wide */
    b.w = 0;                        /* folded immediate, word wide */
    b.w = (unsigned int)(b.w + b.p + b.q);
    return (unsigned int)(b.w + b.p * 3u + b.q);
}

/* A call in the function turns the predicate off entirely — this pins that the
 * with-call path still works, since it is the reason a silent miscompile was
 * never reachable. */
static void note(int v) { g_seen = (unsigned int)(g_seen + (unsigned int)v); }

static int with_call(int seed)
{
    struct rec r;

    r.a = seed & 63;
    r.b = 0;
    note(r.a);
    r.c = 7;
    r.d = 0;
    return r.a + r.b + r.c + r.d + (int)g_seen;
}

void test_leaimm(void)
{
    assertEqual(record(0x1234), 0x07eau);
    assertEqual(record(0x0000), 0x0000u);
    assertEqual(record(0xFFFF), 0x16f1u);

    assertEqual(zero_first(0x1234), 0x00c0u);
    assertEqual(zero_first(0xFFFF), 0x017du);

    assertEqual(all_const(), 49u);

    assertEqual(bytes_const(0x1234), 0x0010u);
    assertEqual(bytes_const(0x000Fu), 0x003cu);

    g_seen = 0;
    assertEqual(with_call(0x1234), 0x006fu);
    g_seen = 0;
    assertEqual(with_call(0x003Fu), 0x0085u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("folded-immediate store through an elided lea");
    suite_add_test(test_leaimm);
    return suite_run();
}
