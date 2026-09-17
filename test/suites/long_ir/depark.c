/* The 8085 frame-word load parks DE around LDSI+LHLX:
 *
 *      push de / ld de,sp+N+2 / ld hl,(de) / pop de
 *
 * because load_to_hl must hand DE back untouched. A backward liveness sweep over
 * the rendered function (filter_dead_bc_parks in ir_lower.c) drops the park where
 * nothing reads the old DE before it is overwritten. `--opt-disable=de-park`
 * keeps every park, so the two modes must agree on every value below.
 *
 * The shapes here are the ones the corpus actually produces, one per way this
 * can go wrong:
 *
 *  - The park protects a WORD staged in DE for an `add hl,de` or `ex de,hl`
 *    that follows the load (wsum, chain): drop it and the arithmetic reads the
 *    slot address instead of the operand.
 *  - It protects a BYTE staged in E alone (setbits/packbits, the bitfield read-
 *    modify-write: `ld a,(hl) / and 248 / or (hl) / ld e,a` then the pointer load
 *    and `ld (hl),e`). A byte in E is invisible to the whole-pair residency cache,
 *    which is exactly why the cache-based version of this test was unsound and
 *    had to be replaced by the liveness sweep — so a value must be live in E
 *    ACROSS a slot load here, or the interesting case is not covered.
 *  - It protects an argument being marshalled for a call (callmix): DE holds one
 *    argument while the next is loaded from a slot. In fcmix the call itself
 *    READS DE — a fastcall long is passed in DE:HL — so the park must survive a
 *    call even though the callee also clobbers the pair.
 *  - Consecutive parks (chain, four slot loads in a row) exercise the sweep's
 *    transparency rule: a later park READS DE (`push de`) but restores it, so it
 *    must not be counted as a reader of the earlier park's value — and the
 *    earlier park is nonetheless dead, because the later `ld de,sp+N` overwrites
 *    the pair. Getting this wrong either way changes a result below.
 *  - lmix keeps a long in DE:HL across word work, so the pair is live for a
 *    reason the sweep must see in the emitted stream, not in the cache.
 *
 * Expected values are literal constants (pk_expect being the exception, and why
 * is explained there). Runs on every CPU; only the 8085 emits the park at all,
 * and the others pin that the shared IR still means the same.
 *
 * MUTATION-TESTED against the sweep, so what this file does and does not pin is
 * on the record:
 *   caught here  — declaring every park dead; ignoring reads of E (the pk_*
 *                  bitfield shape, and the reason char-typed fields are not
 *                  enough: they never leave a byte in E across a pointer load).
 *   caught by    — treating a CALL as not reading DE AT ALL (long_ir's own
 *   a wider gate   test_8085 catches it). Since ADR 0084 a call is read as
 *                  DE-clean only where the EMITTER proved this target takes no
 *                  argument there, which fcmix's fastcall long is not — but
 *                  mutating THAT arm away is caught by nothing in the tree, and
 *                  ADR 0084 says so and why.
 *   not pinned   — ignoring reads of D alone.
 *   SUPERSEDED   — "treating `ret` as not reading DE" was listed here as an
 *                  unpinned mutant. It is no longer a mutant: ADR 0084 made it
 *                  the RULE for a function that does not return in DE, and
 *                  delive.c pins the conservative half (a long return really is
 *                  DE:HL). The call half went the same way, per target.
 *
 * [IR_DEFLOW] The branch-following rule was mutation-tested the same way, and
 * the split is worth knowing before trusting this file alone:
 *   caught here  — the WIN. satband's park is the one site in this file the gate
 *                  moves (dead 11 -> 12 on 8085), so depark_8085 against
 *                  depark_8085_keep is a real differential over it.
 *   caught by    — every OVER-AGGRESSIVE branch mutant: taking the branch
 *   the verifier   target's answer without unioning the fall-through, and
 *                  treating a branch as DE-dead outright. Both are caught by
 *                  IR_DEPARK_SWEEP=1 on the corpus (a VIOLATION in strbench and
 *                  md5), and by NOTHING here — the strbench site needs a park
 *                  whose fall-through reaches a call, and three attempts to
 *                  reduce it (brkeep, brkeep2, a copy of str_compute's loop)
 *                  all failed to reproduce the park placement. It is
 *                  allocation-sensitive, like the other bugs in AGENTS.md's
 *                  real-file list. RUN THE VERIFIER on this rule, do not trust
 *                  the suite alone.
 *   SUPERSEDED   — "the fixpoint's own `ret` and call conservatism" was listed
 *                  here as changing not one park decision. That was measured
 *                  against a blanket optimism; ADR 0084's targeted version moves
 *                  150 8085 asm files and 28 8085 size cells.
 * brkeep, brkeep2 and loopcarry pin no mutant that satband does not. They are
 * kept as cheap coverage of DE live across a forward branch, a fall-through and
 * a loop back-edge — the three edges the fixpoint has to get right — and run on
 * all five CPU variants of this file.
 */
#include "test.h"

struct bf { unsigned char lo; unsigned char hi; unsigned int w; };

/* Real C bitfields, because their read-modify-write is what produces the byte
   staged in E across a slot load: `ld a,(hl) / and 248 / or (hl) / ld e,a` and
   then the pointer load, then `ld (hl),e`. */
struct bits { unsigned char a : 3; unsigned char b : 5; unsigned char c; };

/* The shape that actually stages a byte in E across a slot load, taken from
   bitfieldbench (which provably produces it): int-typed fields, one of them
   SPANNING bytes 1..2, and several read-modify-writes into the same storage. A
   char-typed bitfield does not do it — the byte never has to outlive a pointer
   load. Verified by mutation: making the sweep ignore reads of E changes this
   function's code and breaks the assertions below. */
struct pk {
    unsigned mode  : 3;
    unsigned chan  : 5;
    unsigned rate  : 12;
    unsigned flag  : 1;
    unsigned level : 7;
    unsigned spare : 4;
};

static struct bf    g_bf;
static struct bits  g_bits;
static struct pk    g_pk;
static unsigned int g_vec[4];
static unsigned int g_sink;

/* Six live words with a slot load feeding each operation: the classic
   `push de / ld de,sp+N / ld hl,(de) / pop de` with DE holding the other side. */
static unsigned int wsum(unsigned int a, unsigned int b, unsigned int c, unsigned int d)
{
    unsigned int t1 = (unsigned int)(a + b);
    unsigned int t2 = (unsigned int)(c + d);
    unsigned int t3 = (unsigned int)(a ^ c);
    unsigned int t4 = (unsigned int)(b | d);
    unsigned int t5 = (unsigned int)(t1 + t3);
    unsigned int t6 = (unsigned int)(t2 + t4);
    return (unsigned int)(t1 + t2 + t3 + t4 + t5 + t6);
}

/* A byte staged in E, live across the pointer load that follows. */
static void packbits(struct bf *p, unsigned int v, unsigned int shift)
{
    unsigned char b = (unsigned char)((v >> shift) & 7u);
    p->lo = (unsigned char)((p->lo & 0xF8u) | b);
    p->hi = (unsigned char)((p->hi & 0x1Fu) | (unsigned char)(b << 5));
    p->w  = (unsigned int)(p->w + b);
}

static void pk_set(struct pk *r, unsigned int v)
{
    r->mode  = v & 7u;
    r->chan  = (v >> 3) & 31u;
    r->rate  = (v >> 4) & 4095u;
    r->flag  = (v >> 1) & 1u;
    r->level = (v >> 6) & 127u;
}

static unsigned int pk_get(const struct pk *r)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + r->mode);
    acc = (unsigned int)(acc + (r->chan << 1));
    acc = (unsigned int)(acc + r->rate);
    acc = (unsigned int)(acc + (r->flag << 5));
    acc = (unsigned int)(acc + (r->level << 2));
    return (unsigned int)(acc & 0xffffu);
}

/* What pk_get must return for a value put through pk_set, computed with plain
   shifts and masks. Field ALLOCATION order is implementation-defined, so the
   expectation is written this way rather than as a literal: it pins the values
   without pinning the layout, and a byte corrupted by a dropped park still
   shows up because the field reads back wrong. */
static unsigned int pk_expect(unsigned int v)
{
    unsigned int acc = (unsigned int)(v & 7u);
    acc = (unsigned int)(acc + (((v >> 3) & 31u) << 1));
    acc = (unsigned int)(acc + ((v >> 4) & 4095u));
    acc = (unsigned int)(acc + (((v >> 1) & 1u) << 5));
    acc = (unsigned int)(acc + (((v >> 6) & 127u) << 2));
    return (unsigned int)(acc & 0xffffu);
}

/* Two pointers: the byte comes from one and is stored through the other, so the
   value is in E while the destination pointer is loaded from its frame slot. */
static void setbits(struct bits *p, struct bf *q, unsigned int v)
{
    p->a = (unsigned char)(v & 7u);
    p->b = (unsigned char)((v >> 3) & 31u);
    p->c = (unsigned char)(q->lo ^ (unsigned char)v);
    q->hi = (unsigned char)(p->a | (unsigned char)(p->b << 3));
}

/* A long in DEHL as a REGISTER argument: here the call itself reads DE, so a
   park before it must survive even though the callee clobbers DE. */
static unsigned int lohalf(unsigned long v) __z88dk_fastcall
{
    return (unsigned int)(v >> 16) ^ (unsigned int)(v & 0xFFFFu);
}

static unsigned int fcmix(unsigned long a, unsigned int k)
{
    unsigned int p1 = (unsigned int)(k + 1u);
    unsigned int p2 = (unsigned int)(k << 2);
    unsigned int h  = lohalf(a + (unsigned long)p1);
    return (unsigned int)(h + p1 + p2);
}

static unsigned int addthree(unsigned int a, unsigned int b, unsigned int c)
{
    return (unsigned int)(a + b + c);
}

/* DE holds one argument while the next is loaded from a slot. */
static unsigned int callmix(unsigned int a, unsigned int b)
{
    unsigned int x = (unsigned int)(a * 3u);
    unsigned int y = (unsigned int)(b + 7u);
    unsigned int z = addthree(x, y, (unsigned int)(x ^ y));
    return (unsigned int)(z + x + y);
}

/* Four slot loads in a row: back-to-back parks, most of them dead. */
static unsigned int chain(unsigned int *v)
{
    unsigned int a = v[0], b = v[1], c = v[2], d = v[3];
    unsigned int e = (unsigned int)(a + b);
    unsigned int f = (unsigned int)(c + d);
    unsigned int g = (unsigned int)(e ^ f);
    return (unsigned int)(a + b + c + d + e + f + g);
}

/* A long occupies DE:HL across word work, so DE is live for the whole span. */
static unsigned long lmix(unsigned long x, unsigned int k)
{
    unsigned long a = x << 3;
    unsigned int  b = (unsigned int)(k * 5u);
    unsigned long c = a + (unsigned long)b;
    return c ^ (unsigned long)(b + 1u);
}

/* [IR_DEFLOW] The sweep follows a BRANCH to the liveness its target reports,
   instead of calling every branch a reader of DE. These three pin the three
   answers that rule has to get right.

   satband is the WIN, taken from predbench's sat() where the sweep first found
   it: consecutive `if`s assigning the same local render as a park, a conditional
   branch, and two arms that BOTH start by overwriting DE. Nothing but following
   the branch can see the pair is dead there. */
static int satband(int v)
{
    if (v > 255) v = 255;
    if (v < 0)   v = 0;
    return (v < 64) ? 64 : (v > 192 ? 192 : v);
}

/* brkeep is why a conditional branch UNIONS its target's answer with the
   fall-through's rather than taking either alone: the parked word is read on the
   taken arm and overwritten on the other, so both mutants (target-only,
   fall-through-only) drop a park that one path still needs. */
static unsigned int brkeep(unsigned int a, unsigned int b, unsigned int c,
                           unsigned int k)
{
    unsigned int t = (unsigned int)(a + b);
    unsigned int u = (unsigned int)(c ^ k);
    if (u & 1u) return (unsigned int)(t * 3u + u);
    return (unsigned int)(u + 1u);
}

/* brkeep2 is brkeep with the two arms swapped, and it is the one that catches a
   sweep taking the TARGET's answer alone: here the parked word is read on the
   FALL-THROUGH and the branch target is DE-dead. The pair is needed because the
   two polarities catch opposite mutants -- the real site that exposed this is in
   strbench, where the fall-through reaches `call _my_strlen` and the target does
   not. The call in use() is deliberate: it is what makes the arm read DE. */
static unsigned int deflow_sink;
static unsigned int use(unsigned int v)
{
    deflow_sink = (unsigned int)(deflow_sink + v);
    return v;
}

static unsigned int brkeep2(unsigned int a, unsigned int b, unsigned int c,
                            unsigned int k)
{
    unsigned int t = (unsigned int)(a + b);
    unsigned int u = (unsigned int)(c ^ k);
    if (u & 1u) return (unsigned int)(u + 1u);
    return (unsigned int)(use(t) * 3u + u);
}

/* loopcarry is the BACK-EDGE: the branch target is ABOVE the branch, so the
   fixpoint has to iterate rather than read an answer already computed. The
   carried scale factor is live across the edge, so an optimistic first pass that
   never re-converges drops a park the next iteration reads. */
static unsigned int loopcarry(unsigned int *p, unsigned int n, unsigned int s)
{
    unsigned int acc = 0, i;
    for (i = 0; i < n; i++) {
        acc = (unsigned int)(acc + p[i] * s);
        s   = (unsigned int)(s + p[i]);
    }
    return acc;
}

void test_depark(void)
{
    unsigned long r;

    assertEqual(wsum(0x1234u, 0x5678u, 0x9abcu, 0xdef0u), 0x93b0u);
    assertEqual(wsum(1u, 2u, 3u, 4u), 0x0024u);
    assertEqual(wsum(0xffffu, 0xffffu, 0xffffu, 0xffffu), 0xfff6u);

    /* Each call reads back what the previous one wrote, so a clobbered E shows
       up as a wrong byte rather than being masked by the next write. */
    g_bf.lo = 0xAAu; g_bf.hi = 0xAAu; g_bf.w = 0x1000u;
    packbits(&g_bf, 0x1234u, 4u);
    assertEqual(g_bf.lo, 0xABu); assertEqual(g_bf.hi, 0x6Au); assertEqual(g_bf.w, 0x1003u);
    packbits(&g_bf, 0xFFFFu, 0u);
    assertEqual(g_bf.lo, 0xAFu); assertEqual(g_bf.hi, 0xEAu); assertEqual(g_bf.w, 0x100Au);
    packbits(&g_bf, 0x0007u, 0u);
    assertEqual(g_bf.lo, 0xAFu); assertEqual(g_bf.hi, 0xEAu); assertEqual(g_bf.w, 0x1011u);
    packbits(&g_bf, 0x8000u, 13u);
    assertEqual(g_bf.lo, 0xACu); assertEqual(g_bf.hi, 0x8Au); assertEqual(g_bf.w, 0x1015u);

    pk_set(&g_pk, 0x1234u);
    assertEqual(pk_get(&g_pk), pk_expect(0x1234u));
    pk_set(&g_pk, 0xFFFFu);
    assertEqual(pk_get(&g_pk), pk_expect(0xFFFFu));
    pk_set(&g_pk, 0x0000u);
    assertEqual(pk_get(&g_pk), pk_expect(0x0000u));
    pk_set(&g_pk, 0xA5A5u);
    assertEqual(pk_get(&g_pk), pk_expect(0xA5A5u));
    pk_set(&g_pk, 0x5A5Au);
    assertEqual(pk_get(&g_pk), pk_expect(0x5A5Au));

    /* g_bf.lo is 0xAC here, and setbits stores through the OTHER pointer while
       the byte sits in E. */
    setbits(&g_bits, &g_bf, 0x1234u);
    assertEqual(g_bits.a, 0x04u); assertEqual(g_bits.b, 0x06u);
    assertEqual(g_bits.c, 0x98u); assertEqual(g_bf.hi, 0x34u);
    setbits(&g_bits, &g_bf, 0xFFFFu);
    assertEqual(g_bits.a, 0x07u); assertEqual(g_bits.b, 0x1Fu);
    assertEqual(g_bits.c, 0x53u); assertEqual(g_bf.hi, 0xFFu);

    assertEqual(fcmix(0x01234567UL, 0x1234u), 0xb1c4u);
    assertEqual(fcmix(0xFFFF0001UL, 0x00FFu), 0x03fau);

    assertEqual(callmix(0x1111u, 0x2222u), 0xbbd2u);
    assertEqual(callmix(0xF000u, 0x0FFFu), 0x8012u);

    g_vec[0] = 0x0101u; g_vec[1] = 0x0202u; g_vec[2] = 0x0404u; g_vec[3] = 0x0808u;
    assertEqual(chain(g_vec), 0x2d2du);
    g_vec[0] = 0xfffeu; g_vec[1] = 0x0003u; g_vec[2] = 0x8000u; g_vec[3] = 0x8001u;
    assertEqual(chain(g_vec), 0x0004u);

    r = lmix(0x01234567UL, 0x1234u);
    assertEqual((unsigned int)(r & 0xFFFFu), 0xdd39u);
    assertEqual((unsigned int)(r >> 16), 0x091au);
    r = lmix(0xFFFFFFFFUL, 0xFFFFu);
    assertEqual((unsigned int)(r & 0xFFFFu), 0x000fu);
    assertEqual((unsigned int)(r >> 16), 0x0000u);

    g_sink = wsum(0x0f0fu, 0xf0f0u, 0x00ffu, 0xff00u);
    assertEqual(g_sink, wsum(0x0f0fu, 0xf0f0u, 0x00ffu, 0xff00u));

    /* [IR_DEFLOW] Both arms of each `if` are taken across these five, so the
       park the sweep now drops is exercised on every path through it. */
    assertEqual(satband(-5), 64);
    assertEqual(satband(10), 64);
    assertEqual(satband(100), 100);
    assertEqual(satband(300), 192);
    assertEqual(satband(200), 192);

    /* Odd u takes the arm that READS the parked t; even u overwrites DE. */
    assertEqual(brkeep(0x1111u, 0x2222u, 0x0F0Fu, 0x0F0Eu), 0x999au);
    assertEqual(brkeep(0xF0F0u, 0x0101u, 0xF0F0u, 0x0F0Eu), 0xffffu);
    assertEqual(brkeep(0xFFFFu, 0xFFFFu, 0x8000u, 0x0001u), 0x7ffbu);
    assertEqual(brkeep(0x0123u, 0x4567u, 0x89ABu, 0xCDE0u), 0x17e9u);

    /* The mirror: the parked word is read on the FALL-THROUGH arm here. */
    deflow_sink = 0;
    assertEqual(brkeep2(0x1111u, 0x2222u, 0x0F0Fu, 0x0F0Eu), 0x0002u);
    assertEqual(brkeep2(0xF0F0u, 0x0101u, 0xF0F0u, 0x0F0Eu), 0xd5d1u);
    assertEqual(brkeep2(0xFFFFu, 0xFFFFu, 0x8000u, 0x0001u), 0x8002u);
    assertEqual(brkeep2(0x0123u, 0x4567u, 0x89ABu, 0xCDE2u), 0x444au);
    assertEqual(deflow_sink, 0xf1f1u);

    g_vec[0] = 0x0101u; g_vec[1] = 0x0202u; g_vec[2] = 0x0404u; g_vec[3] = 0x0808u;
    assertEqual(loopcarry(g_vec, 4u, 0x1234u), 0xa952u);
    assertEqual(loopcarry(g_vec, 2u, 0xFFFFu), 0x00ffu);
    g_vec[0] = 0xfffeu; g_vec[1] = 0x0003u; g_vec[2] = 0x8000u; g_vec[3] = 0x8001u;
    assertEqual(loopcarry(g_vec, 4u, 0x0007u), 0x8009u);
    assertEqual(loopcarry(g_vec, 3u, 0x8000u), 0xfffau);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 dead de park elision");
    suite_add_test(test_depark);
    return suite_run();
}
