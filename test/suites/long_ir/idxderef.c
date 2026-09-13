/* [idx-deref] A pointer homed in IX/IY is an ADDRESSING MODE, not a carrier.
 *
 * Two halves that only pay together, and only make sense together:
 *
 *   1. idx_deref_reg (ir_lower_ops.inc.c) — a MEM_VREG access whose base is
 *      index-homed reads or writes its field as `(ix+d)` instead of coming
 *      back through `push iy; pop hl`.
 *   2. ir_opt_deref_offset (ir_opt.c) — `t = p + K; *t` folds into
 *      `*(p + K)`, which is what puts K in mem.offset where the rung can
 *      spell it as the displacement.
 *
 * The whole point is that the two halves change WHICH REGISTER holds the
 * pointer and HOW MANY BYTES the access costs, never what it reads. So the
 * only thing a behavioural test can pin is exactly that: the values must not
 * move. ►► Size is NOT testable here — `--opt-disable=idx-deref` leaves this
 * test PASSING, as it must. The corpus size scan is the only gate that sees
 * the win, and the BENCH_MATRIX regeneration is the only gate that has ever
 * caught a silent miscompile in this area.
 *
 * What each function is FOR:
 *
 *   bf_set / bf_get   the reg_set/reg_get shape this was built for: a
 *                     read-only struct-pointer param with enough field
 *                     traffic that the pointer would otherwise spill.
 *                     Bitfields put the accesses at offsets 0..3, which is
 *                     the displacement range the rung covers.
 *   wide_get/wide_set WORD fields, so the two-displaced-byte-moves path
 *                     (`ld l,(ix+d); ld h,(ix+d+1)`) is exercised and not
 *                     only the byte one. A wrong d+1 shows as a swapped or
 *                     half-stale word, not as a crash.
 *   far_get           a field PAST the signed displacement byte. The rung
 *                     must decline it and the generic path must still be
 *                     correct — the failure mode if the range test were
 *                     wrong is a wrapped displacement reading the WRONG
 *                     field, which is silent.
 *   step_sum          a STEPPED pointer. The fold rejects it (a walking
 *                     pointer wants HL/BC). If that leaked, the step would
 *                     be lost and the sum would repeat one element.
 *   alias_set         the pointer written THROUGH, then read back through
 *                     the same base at a different offset, so a stale HL
 *                     belief left by the store would be caught.
 *   hoisted_base      an address temp formed BEFORE its base is reassigned
 *                     (`int *t = &p->c; p = r; x = *t;`). The IR is not SSA,
 *                     so folding `*t` back to `*(p + K)` here would read the
 *                     NEW pointer's field. ir_opt_deref_offset only admits a
 *                     base with no def in the function at all — a read-only
 *                     parameter — which is why this cannot arise; the test
 *                     exists so that relaxing that gate is caught. Verified:
 *                     dropping the def-count gate entirely makes this case
 *                     fail. It does NOT distinguish `ndef == 0` from
 *                     `ndef <= 1` — no C program was found that separates
 *                     them — so treat the one-def boundary as unproven.
 *
 * ►► ONE GUARD IS NOT COVERED, DELIBERATELY. idx_deref_reg also rejects a
 * post_step access (the deref reads and steps the base itself). No test here
 * can reach it: idx2_home_realizable refuses a stepped base an index home in
 * the first place (IDX2_BASE_STEPPED), so a post-stepped MEM_VREG never HAS
 * an index-homed base. Verified by removing the guard — this suite still
 * passes. The guard is kept because lifting the STEPPED exclusion is an open
 * item; whoever lifts it must re-prove this by breaking the guard first.
 *
 * Constants are derived by hand below; no printf (it perturbs allocation).
 */
#include "test.h"

struct bf { unsigned mode:3; unsigned chan:5; unsigned rate:12;
            unsigned flag:1; unsigned level:7; unsigned spare:4; };

static struct bf bfs[4];

static void bf_set(struct bf *r, unsigned int v)
{
    r->mode  = v & 7u;
    r->chan  = (v >> 3) & 31u;
    r->rate  = (v >> 4) & 4095u;
    r->flag  = (v >> 1) & 1u;
    r->level = (v >> 6) & 127u;
}

static unsigned int bf_get(const struct bf *r)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + r->mode);
    acc = (unsigned int)(acc + (r->chan << 1));
    acc = (unsigned int)(acc + r->rate);
    acc = (unsigned int)(acc + (r->flag << 5));
    acc = (unsigned int)(acc + (r->level << 2));
    return acc & 0xffffu;
}

/* WORD fields at four displacements — the `ld l,(ix+d); ld h,(ix+d+1)` path.
   The shifts keep each field distinct so a swapped half is visible. */
struct quad { unsigned int a, b, c, d; };
static struct quad quads[3];

static void wide_set(struct quad *q, unsigned int v)
{
    q->a = v;
    q->b = (unsigned int)(v ^ 0xff00u);
    q->c = (unsigned int)(v + 0x0102u);
    q->d = (unsigned int)(v << 8);
}

static unsigned int wide_get(const struct quad *q)
{
    return (unsigned int)(q->a + q->b + q->c + q->d);
}

/* A field beyond the signed displacement byte: the rung must decline and the
   generic address path must still read the right member. */
struct big { unsigned char pad[200]; unsigned int tail; unsigned char last; };
static struct big one_big;

static unsigned int far_get(const struct big *b)
{
    return (unsigned int)(b->tail + b->last + b->pad[0] + b->pad[199]);
}

/* Stepped pointer — must stay on the walking-pointer path in both halves. */
static unsigned int step_sum(const unsigned int *p, int n)
{
    unsigned int s = 0;
    while (n--) s = (unsigned int)(s + *p++);
    return s;
}

/* An address temp formed before its base is reassigned. See the header: the
   fold must not rewrite `*t` into `*(p + K)` when `p` is not read-only. */
static unsigned int hoisted_base(struct quad *q, struct quad *r, int pick)
{
    struct quad *p = q;
    unsigned int *t = &p->c;      /* the address of the OLD p's field */
    if (pick) p = r;              /* ... and now p is a different pointer */
    return (unsigned int)(*t + p->a);
}

/* Write through the base, then read back through it at another offset. */
static unsigned int alias_set(struct quad *q, unsigned int v)
{
    q->a = v;
    q->b = (unsigned int)(q->a + 1u);
    q->c = (unsigned int)(q->b + 1u);
    q->d = (unsigned int)(q->c + 1u);
    return (unsigned int)(q->a + q->d);
}

static void test_idxderef(void)
{
    int k;
    unsigned int acc;

    /* bitfields: same storage written and read back through the fields only,
       so the result does not depend on bitfield allocation order. */
    acc = 0;
    for (k = 0; k < 4; k++) bf_set(&bfs[k], (unsigned int)(k * 4241u + 7u));
    for (k = 0; k < 4; k++) {
        unsigned int v = (unsigned int)(k * 4241u + 7u);
        unsigned int want = (unsigned int)((v & 7u)
                          + (((v >> 3) & 31u) << 1)
                          + ((v >> 4) & 4095u)
                          + (((v >> 1) & 1u) << 5)
                          + (((v >> 6) & 127u) << 2));
        assertEqual(bf_get(&bfs[k]), want & 0xffffu);
        acc = (unsigned int)(acc + bf_get(&bfs[k]));
    }

    /* word fields */
    for (k = 0; k < 3; k++) wide_set(&quads[k], (unsigned int)(0x1234u + k * 0x1111u));
    for (k = 0; k < 3; k++) {
        unsigned int v = (unsigned int)(0x1234u + k * 0x1111u);
        unsigned int want = (unsigned int)(v + (v ^ 0xff00u) + (v + 0x0102u)
                                           + (unsigned int)(v << 8));
        assertEqual(quads[k].a, v);
        assertEqual(quads[k].b, (unsigned int)(v ^ 0xff00u));
        assertEqual(quads[k].c, (unsigned int)(v + 0x0102u));
        assertEqual(quads[k].d, (unsigned int)(v << 8));
        assertEqual(wide_get(&quads[k]), want);
    }

    /* out-of-displacement-range members */
    one_big.pad[0]   = 11;
    one_big.pad[199] = 22;
    one_big.tail     = 3000;
    one_big.last     = 33;
    assertEqual(far_get(&one_big), (unsigned int)(3000 + 33 + 11 + 22));

    /* stepped walk over the same storage the word fields wrote */
    wide_set(&quads[0], 0x0101u);
    wide_set(&quads[1], 0x0202u);
    wide_set(&quads[2], 0x0303u);
    {
        unsigned int want = 0;
        for (k = 0; k < 3; k++) {
            unsigned int v = (unsigned int)(0x0101u * (unsigned int)(k + 1));
            want = (unsigned int)(want + v + (v ^ 0xff00u) + (v + 0x0102u)
                                  + (unsigned int)(v << 8));
        }
        assertEqual(step_sum(&quads[0].a, 12), want);
        /* a partial walk, so a wrong stride is a wrong sum rather than
           coincidentally matching the whole-array total */
        assertEqual(step_sum(&quads[0].a, 2),
                    (unsigned int)(0x0101u + (0x0101u ^ 0xff00u)));
    }

    /* the hoisted address temp must still name the pointer it was taken from */
    wide_set(&quads[0], 0x0101u);
    wide_set(&quads[1], 0x0202u);
    assertEqual(hoisted_base(&quads[0], &quads[1], 0),
                (unsigned int)(quads[0].c + quads[0].a));
    assertEqual(hoisted_base(&quads[0], &quads[1], 1),
                (unsigned int)(quads[0].c + quads[1].a));

    /* read-back through the written base */
    assertEqual(alias_set(&quads[0], 1000u), (unsigned int)(1000u + 1003u));
    assertEqual(quads[0].b, 1001u);
    assertEqual(quads[0].c, 1002u);
    assertEqual(quads[0].d, 1003u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("index-homed deref base reached as (ix+d)");
    suite_add_test(test_idxderef);
    return suite_run();
}
