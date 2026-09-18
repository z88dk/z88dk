/* [z80n-add-a] z80n `add hl,a` for a zero-extended byte added to HL.
 *
 * `ld e,a; ld d,0; add hl,de` (4 B, 22 cyc, and it spends DE) becomes
 * `add hl,a` (2 B, 8 cyc, DE untouched). The pair is usually NOT adjacent to
 * the add — the base arrives in between — so the rung walks a bounded window,
 * and every line in it must preserve A and leave D and E unread.
 *
 * What each function is FOR, verified by diffing the z80n asm per function,
 * gate-on against gate-off:
 *
 *  - djb2      THE firing shape, and the corpus's own (hashbench's hash loop).
 *              A byte read through a STEPPED POINTER accumulated into HL: the
 *              pointer takes a BC home, so the base does not need DE and the
 *              widened byte dies at the add.
 *  - addbyte   the same shape with a different multiplier, so one const-fold
 *              path does not carry the whole test.
 *  - carry_add must NOT change, and it is a TRIPWIRE, not a live gate: the
 *              widen pair is there but the add that consumes it is
 *              `ld hl,de; add hl,bc`, so the shape never reaches the rung.
 *  - de_twice  must NOT change, also a tripwire: the twice-used byte gets a BC
 *              home (`ld l,a; ld h,0; ld bc,hl`), so no candidate pair arises.
 *
 * The guards themselves are exercised by the CORPUS, not by this file: of 20
 * census sites, 15 are declined — on DE live after the add (divbench's `udiv`,
 * where the following `ret` reads DE under the long result ABI) or on F. Both
 * facts are in adr/0078. Saying so here is deliberate: claiming a guard a test
 * does not reach is how the LDSI and LDHI tests first went wrong.
 *
 * Every CPU but z80n is a control — none of them has ED 31, and their asm must
 * be untouched. Self-verifying, no printf.
 */
#include "test.h"

static unsigned char tab[8] = { 3, 9, 17, 33, 65, 129, 200, 250 };
static unsigned int  acc;

/* hashbench's djb2: h * 33 + byte. */
static unsigned int djb2(const unsigned char *k, int n)
{
    unsigned int h = 5381u;
    int i;

    for (i = 0; i < n; i++)
        h = (unsigned int)(((h << 5) + h + k[i]) & 0xffffu);
    return h;
}

static unsigned int addbyte(const unsigned char *p, int n)
{
    unsigned int s = 0;
    int i;

    for (i = 0; i < n; i++)
        s = (unsigned int)(((s * 3u) + p[i]) & 0xffffu);
    return s;
}

/* The carry out of the add IS the answer, so the rung must decline. */
static unsigned int carry_add(unsigned int base, unsigned char b)
{
    unsigned int s = base + (unsigned int)b;
    return (s < base) ? 0xffffu : s;
}

/* The zero-extended byte is added twice: DE is live past the first add. */
static unsigned int de_twice(unsigned int a, unsigned int b, unsigned char c)
{
    unsigned int x = a + (unsigned int)c;
    unsigned int y = b + (unsigned int)c;
    return x + y;
}

void test_znadda(void)
{
    assertEqual(djb2(tab, 4), 0xdd43u);
    assertEqual(djb2(tab, 8), 0xaae7u);
    assertEqual(djb2(tab + 4, 4), 0xf3a9u);

    assertEqual(addbyte(tab, 4), 246u);
    assertEqual(addbyte(tab, 8), 23692u);

    assertEqual(carry_add(0xfff0u, 200u), 0xffffu);
    assertEqual(carry_add(0x1000u, 200u), 0x10c8u);

    assertEqual(de_twice(10u, 20u, 7u), 44u);
    assertEqual(de_twice(0u, 0u, 250u), 500u);

    acc = djb2(tab, 2) + addbyte(tab, 2);
    assertEqual(acc, 0x6ac3u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("z80n add hl,a for zero-extended bytes");
    suite_add_test(test_znadda);
    return suite_run();
}
