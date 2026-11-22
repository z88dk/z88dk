/* [ldhi-addr] 8085 pointer-plus-constant address formation via LDHI.
 *
 * `ld de,N; add hl,de` (4 B, 20 cyc) becomes `ld de,hl+N; ex de,hl` (3 B, 14)
 * — LDSI's sibling, with the same three hazards, and like LDSI each one fails
 * SILENTLY: a plausible wrong number, not a crash.
 *
 * What each function is FOR, verified by diffing the 8085 asm gate-on against
 * gate-off per function (the house rule; the first LDSI test passed while the
 * rung fired nowhere in it):
 *
 *  - ctx_init   THE firing shape, 3 sites. Long members written through a
 *               POINTER parameter: each store forms `pointer + member offset`
 *               and the value travels the long-store path, so DE is dead at
 *               the formation. This is what converts in the corpus (md5
 *               MD5Init, structbench, recordbench). Driven by ctx_use, which
 *               reads every member back, so a wrong address is a wrong answer.
 *  - const_add  fires once, on `n * 3 + 11`. The rung is not address-specific:
 *               any `HL += small constant` qualifies. Pinned because the sum
 *               is returned.
 *  - big_off    must NOT change, and carries BOTH decline classes: two
 *               in-range sites (`ld de,7`, `ld de,9`) declined because DE is
 *               live after them, and three (299, 300, 302) declined on range.
 *               LDHI's operand is one unsigned byte (`(hl) +
 *               get_memory_inst(pc++)` in src/ticks/i8085_inst.c), and
 *               out-of-range is COMMON for this rung, unlike LDSI: the added
 *               constant is program data, not a frame offset.
 *  - carry_live must NOT change. `add hl,de` (DAD D) WRITES CARRY and LDHI
 *               does not, so a borrow read after the formation would be
 *               stale. The shape produces no adjacent candidate pair today,
 *               so this is a tripwire on a future widening, not a live gate.
 *  - ctx_use    must NOT change: its own `ld de,0; add hl,de` is declined.
 *
 * Runs on every CPU: 8080/gbz80/rabbit have no LDHI and must be unaffected,
 * which makes them the control. Self-verifying, and no printf (it perturbs
 * allocation and can mask exactly this class of bug — see the enigma family).
 */
#include "test.h"

static unsigned int g_sink;
static void sink(unsigned int x) { g_sink += x; }

/* The shape that converts in the corpus (md5 MD5Init, structbench, recordbench):
   long members of a struct written through a POINTER. Each store forms
   `pointer + member offset`, and the value itself travels through the long
   store path, so DE is dead at the formation. */
struct ctx { unsigned long a, b, c, d; unsigned int tag; };

static void ctx_init(struct ctx *p)
{
    p->a = 0x67452301UL;
    p->b = 0xefcdab89UL;
    p->c = 0x98badcfeUL;
    p->d = 0x10325476UL;
    p->tag = 0x1234u;
}

static unsigned int ctx_use(unsigned int n)
{
    struct ctx c;
    unsigned int s;

    ctx_init(&c);
    c.a += (unsigned long)n;
    c.c ^= c.b;
    c.d += c.a;
    s = (unsigned int)(c.a & 0xffffUL);
    s += (unsigned int)(c.b >> 16);
    s += (unsigned int)(c.c & 0xffffUL);
    s += (unsigned int)(c.d >> 16);
    return (unsigned int)((s + c.tag) & 0xffffu);
}

/* Not an address at all: `n * 3 + 11` forms `HL += 11`, which the rung takes.
   Kept as a separate function so the general shape is pinned on its own. */
static unsigned int const_add(struct ctx *p, unsigned int n)
{
    unsigned int keep = n * 3u + 11u;
    unsigned int s = 0;

    s += (unsigned int)(p->a & 0xffffUL) + keep;
    s += (unsigned int)(p->b & 0xffffUL) + keep;
    s += (unsigned int)(p->c & 0xffffUL) + keep;
    return s + keep;
}

/* The borrow from the comparison must survive any formation between it and its
   use. No adjacent candidate pair arises here today — see the header. */
static unsigned int carry_live(struct ctx *p, unsigned int x, unsigned int y)
{
    int borrow = (x < y);
    unsigned int s = 0;

    s += (unsigned int)(p->a & 0xffffUL);
    s += (unsigned int)(p->d & 0xffffUL);
    return borrow ? (s + 1u) : s;
}

/* Members past LDHI's 0..255 operand range, PLUS two in-range formations whose
   DE is live afterwards. Both decline classes in one function. */
struct wide { unsigned char pad[300]; unsigned int hi; unsigned int lo; };

static unsigned int big_off(struct wide *w, unsigned int n)
{
    w->hi = n + 7u;
    w->lo = n + 9u;
    w->pad[0] = (unsigned char)n;
    w->pad[299] = (unsigned char)(n + 1u);
    return (unsigned int)((w->hi + w->lo + w->pad[0] + w->pad[299]) & 0xffffu);
}

static struct ctx  g_ctx;
static struct wide g_wide;

void test_ldhiaddr(void)
{
    assertEqual(ctx_use(0), 0x13f0u);
    assertEqual(ctx_use(5), 0x13f5u);
    assertEqual(ctx_use(0x8000), 0x93f0u);

    ctx_init(&g_ctx);
    assertEqual(const_add(&g_ctx, 0), 0xabb4u);
    assertEqual(const_add(&g_ctx, 7), 0xac08u);

    assertEqual(carry_live(&g_ctx, 3, 9), 0x7778u);
    assertEqual(carry_live(&g_ctx, 9, 3), 0x7777u);

    assertEqual(big_off(&g_wide, 0), 17u);
    assertEqual(big_off(&g_wide, 100), 417u);

    sink(ctx_use(1));
    sink(big_off(&g_wide, 2));
    assertEqual(g_sink, 0x140au);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 LDHI pointer-plus-constant addressing");
    suite_add_test(test_ldhiaddr);
    return suite_run();
}
