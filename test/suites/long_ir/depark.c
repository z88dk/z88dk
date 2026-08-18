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
 *   caught by    — treating a CALL as not reading DE (long_ir's own test_8085
 *   a wider gate   catches it; __sdcccall(1) and fastcall pass arguments there).
 *   not pinned   — ignoring reads of D alone, and treating `ret` as not reading
 *                  DE. Both mutants drop extra parks that turn out to be harmless
 *                  on every input in the tree, so no test here fails; the
 *                  conservatism is kept on the ABI argument (a long or float
 *                  result IS returned in DE:HL, and `ld a,d` alone appears 529
 *                  times in the 8085 corpus) rather than on evidence.
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
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 dead de park elision");
    suite_add_test(test_depark);
    return suite_run();
}
