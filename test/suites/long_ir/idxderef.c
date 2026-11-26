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

/* A single-def copy of a read-only param in the entry block names the same
   pointer as the param, so the fold may go through it (read() does
   `fc = (struct fcb *)fd`). Both the pointer-to-pointer and the int-to-pointer
   spelling. */
static unsigned int copy_get(struct quad *q)
{
    struct quad *p = q;
    p->a = (unsigned int)(p->b + 1u);
    return (unsigned int)(p->a + p->b + p->c + p->d);
}

static unsigned int cast_get(unsigned int fd)
{
    struct quad *p = (struct quad *)fd;
    p->c = (unsigned int)(p->d + 2u);
    return (unsigned int)(p->a + p->b + p->c + p->d);
}

/* A copy with a second def is NOT the param: it must keep reading the pointer
   it holds NOW. The fold must not rewrite these accesses to the param. */
static unsigned int recopy_get(struct quad *q, struct quad *r, int pick)
{
    struct quad *p = q;
    unsigned int s = (unsigned int)(p->a + p->b);
    if (pick) p = r;
    return (unsigned int)(s + p->a + p->b + p->c + p->d);
}

/* Long arithmetic next to a pointer read at several fields. The Z80 long
   helpers (or/and/xor/mult/div) pop their return address into IX, so a pointer
   parked in IX across one would be destroyed. Every field is read AFTER each
   long op, so a clobbered IX shows as a wrong field or a wild read. */
struct lmix { unsigned long a; unsigned long b; unsigned int w; unsigned int v; unsigned char c; };
static struct lmix lm;

static unsigned long long_mix(struct lmix *q, unsigned long x)
{
    unsigned long r = q->a | x;
    r = r + q->w;
    r = r ^ q->b;
    r = r * (unsigned long)q->v;
    r = r + q->c;
    r = r / (unsigned long)(q->c + 1u);
    r = r & q->a;
    return r + q->w + q->v;
}

/* fp mode, a function with calls: a parameter read at many fields rides IY across
   the calls (callees save IY). The allocator takes the home only when the field
   reads outweigh the calls, about 30 with one call and about 40 with two, so this
   reads 48 fields with two calls between them. A home that did not survive a call
   would read through a stale register. */
struct big12 { unsigned int f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11; };
static struct big12 b12;
static unsigned int g_bump;
static unsigned int bump(unsigned int x)
{
    g_bump = (unsigned int)(g_bump + 1u);
    return (unsigned int)(x + g_bump);
}

static unsigned int fpcalls_sum(struct big12 *q)
{
    unsigned int s = 0;
    s = (unsigned int)(s + q->f0);
    s = (unsigned int)(s + q->f1);
    s = (unsigned int)(s + q->f2);
    s = (unsigned int)(s + q->f3);
    s = (unsigned int)(s + q->f4);
    s = (unsigned int)(s + q->f5);
    s = (unsigned int)(s + q->f6);
    s = (unsigned int)(s + q->f7);
    s = (unsigned int)(s + q->f8);
    s = (unsigned int)(s + q->f9);
    s = (unsigned int)(s + q->f10);
    s = (unsigned int)(s + q->f11);
    s = (unsigned int)(s + q->f0);
    s = (unsigned int)(s + q->f1);
    s = (unsigned int)(s + q->f2);
    s = (unsigned int)(s + q->f3);
    s = (unsigned int)(s + bump(s));
    s = (unsigned int)(s + q->f4);
    s = (unsigned int)(s + q->f5);
    s = (unsigned int)(s + q->f6);
    s = (unsigned int)(s + q->f7);
    s = (unsigned int)(s + q->f8);
    s = (unsigned int)(s + q->f9);
    s = (unsigned int)(s + q->f10);
    s = (unsigned int)(s + q->f11);
    s = (unsigned int)(s + q->f0);
    s = (unsigned int)(s + q->f1);
    s = (unsigned int)(s + q->f2);
    s = (unsigned int)(s + q->f3);
    s = (unsigned int)(s + q->f4);
    s = (unsigned int)(s + q->f5);
    s = (unsigned int)(s + q->f6);
    s = (unsigned int)(s + q->f7);
    s = (unsigned int)(s + bump(s));
    s = (unsigned int)(s + q->f8);
    s = (unsigned int)(s + q->f9);
    s = (unsigned int)(s + q->f10);
    s = (unsigned int)(s + q->f11);
    s = (unsigned int)(s + q->f0);
    s = (unsigned int)(s + q->f1);
    s = (unsigned int)(s + q->f2);
    s = (unsigned int)(s + q->f3);
    s = (unsigned int)(s + q->f4);
    s = (unsigned int)(s + q->f5);
    s = (unsigned int)(s + q->f6);
    s = (unsigned int)(s + q->f7);
    s = (unsigned int)(s + q->f8);
    s = (unsigned int)(s + q->f9);
    s = (unsigned int)(s + q->f10);
    s = (unsigned int)(s + q->f11);
    return s;
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

    /* a copy of the param stands for the param */
    wide_set(&quads[0], 0x0101u);
    wide_set(&quads[1], 0x0202u);
    assertEqual(copy_get(&quads[0]),
                (unsigned int)(quads[0].a + quads[0].b + quads[0].c + quads[0].d));
    assertEqual(quads[0].a, (unsigned int)(quads[0].b + 1u));
    assertEqual(cast_get((unsigned int)&quads[1]),
                (unsigned int)(quads[1].a + quads[1].b + quads[1].c + quads[1].d));
    assertEqual(quads[1].c, (unsigned int)(quads[1].d + 2u));

    /* a re-assigned copy follows the new value */
    wide_set(&quads[0], 0x0303u);
    wide_set(&quads[1], 0x0404u);
    assertEqual(recopy_get(&quads[0], &quads[1], 0),
                (unsigned int)(2u * (quads[0].a + quads[0].b) + quads[0].c + quads[0].d));
    assertEqual(recopy_get(&quads[0], &quads[1], 1),
                (unsigned int)(quads[0].a + quads[0].b + quads[1].a + quads[1].b
                               + quads[1].c + quads[1].d));

    /* long helpers beside an index-homed pointer */
    lm.a = 0x00ff00ffUL; lm.b = 0x0f0f0f0fUL; lm.w = 7; lm.v = 3; lm.c = 4;
    {
        unsigned long x = 0x12345678UL, r;
        r = lm.a | x;
        r = r + lm.w;
        r = r ^ lm.b;
        r = r * (unsigned long)lm.v;
        r = r + lm.c;
        r = r / (unsigned long)(lm.c + 1u);
        r = r & lm.a;
        r = r + lm.w + lm.v;
        assertEqual(long_mix(&lm, x) == r, 1);
    }

    /* 48 field reads with calls between them, against a plain-array mirror */
    {
        unsigned int v[12], s = 0, want;
        for (k = 0; k < 12; k++) v[k] = (unsigned int)(0x0101u * (unsigned int)(k + 1) + 3u);
        b12.f0 = v[0]; b12.f1 = v[1]; b12.f2 = v[2]; b12.f3 = v[3]; b12.f4 = v[4]; b12.f5 = v[5];
        b12.f6 = v[6]; b12.f7 = v[7]; b12.f8 = v[8]; b12.f9 = v[9]; b12.f10 = v[10]; b12.f11 = v[11];
        g_bump = 0;
        s = (unsigned int)(s + v[0]);
        s = (unsigned int)(s + v[1]);
        s = (unsigned int)(s + v[2]);
        s = (unsigned int)(s + v[3]);
        s = (unsigned int)(s + v[4]);
        s = (unsigned int)(s + v[5]);
        s = (unsigned int)(s + v[6]);
        s = (unsigned int)(s + v[7]);
        s = (unsigned int)(s + v[8]);
        s = (unsigned int)(s + v[9]);
        s = (unsigned int)(s + v[10]);
        s = (unsigned int)(s + v[11]);
        s = (unsigned int)(s + v[0]);
        s = (unsigned int)(s + v[1]);
        s = (unsigned int)(s + v[2]);
        s = (unsigned int)(s + v[3]);
        g_bump = (unsigned int)(g_bump + 1u); s = (unsigned int)(s + (unsigned int)(s + g_bump));
        s = (unsigned int)(s + v[4]);
        s = (unsigned int)(s + v[5]);
        s = (unsigned int)(s + v[6]);
        s = (unsigned int)(s + v[7]);
        s = (unsigned int)(s + v[8]);
        s = (unsigned int)(s + v[9]);
        s = (unsigned int)(s + v[10]);
        s = (unsigned int)(s + v[11]);
        s = (unsigned int)(s + v[0]);
        s = (unsigned int)(s + v[1]);
        s = (unsigned int)(s + v[2]);
        s = (unsigned int)(s + v[3]);
        s = (unsigned int)(s + v[4]);
        s = (unsigned int)(s + v[5]);
        s = (unsigned int)(s + v[6]);
        s = (unsigned int)(s + v[7]);
        g_bump = (unsigned int)(g_bump + 1u); s = (unsigned int)(s + (unsigned int)(s + g_bump));
        s = (unsigned int)(s + v[8]);
        s = (unsigned int)(s + v[9]);
        s = (unsigned int)(s + v[10]);
        s = (unsigned int)(s + v[11]);
        s = (unsigned int)(s + v[0]);
        s = (unsigned int)(s + v[1]);
        s = (unsigned int)(s + v[2]);
        s = (unsigned int)(s + v[3]);
        s = (unsigned int)(s + v[4]);
        s = (unsigned int)(s + v[5]);
        s = (unsigned int)(s + v[6]);
        s = (unsigned int)(s + v[7]);
        s = (unsigned int)(s + v[8]);
        s = (unsigned int)(s + v[9]);
        s = (unsigned int)(s + v[10]);
        s = (unsigned int)(s + v[11]);
        want = s;
        g_bump = 0;
        assertEqual(fpcalls_sum(&b12), want);
    }

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
