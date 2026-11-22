/* 8085 DSUB (`sub hl,bc`) subtract lowering. DSUB replaces the byte-wise
 * `ld a,l / sub c / ld l,a / ld a,h / sbc a,b / ld h,a` form at four shapes in
 * gen_sub, and each one has a distinct way to go wrong:
 *
 *  - sub_long      32-bit a-b with both operands in memory. DSUB does the LOW
 *                  half and the byte-wise `sbc a,` chain finishes the high
 *                  half, so the CARRY DSUB leaves must be a true borrow and
 *                  must survive the `pop bc` / `ld a,c` that sit between them.
 *                  Cases straddle a low-half borrow (0x00000000-1) and no
 *                  borrow, in both directions.
 *  - sub_long_k    the same low half against a CONSTANT, staged `ld bc,K`.
 *                  K values pin the low half at 0 and at 0xffff.
 *  - sub_word_bc   16-bit subtract with the subtrahend already in BC — DSUB
 *                  reads BC where it sits, so a swapped operand order (DSUB is
 *                  HL-BC, and subtraction does not commute) shows up here.
 *  - sub_word_de   16-bit subtract with the subtrahend in DE, staged via
 *                  `ld bc,de`. Only taken when the function has no BC home and
 *                  nothing is parked in BC; a stale BC belief or an evicted BC
 *                  home would corrupt an unrelated value, so the function also
 *                  carries live values across the subtract.
 *  - sub_word_home is the counter-case: a loop whose induction variable wants
 *                  a BC home. The DE staging must NOT fire and must not eat the
 *                  home, so the sum pins both the arithmetic and the home.
 *
 * Unsigned wrap is used deliberately (defined behaviour) so the borrow paths
 * are reachable without signed overflow. Expected values are literal constants,
 * not recomputations, so a consistently-wrong lowering cannot self-agree.
 * Runs on every CPU — only the 8085 takes the DSUB path, and the others pin
 * that the shared IR still means the same thing. No printf (it perturbs
 * allocation and can mask the very shapes under test).
 */
#include "test.h"

static unsigned long  gl_a, gl_b;
static unsigned int   gw_a, gw_b;
static unsigned long  g_acc;

/* 32-bit subtract, both operands from memory: DSUB low half + sbc chain. */
static unsigned long sub_long(unsigned long a, unsigned long b)
{
    gl_a = a; gl_b = b;
    return gl_a - gl_b;
}

/* 32-bit subtract of a constant: `ld bc,K_low; sub hl,bc` + sbc chain. */
static unsigned long sub_long_k(unsigned long a)
{
    gl_a = a;
    return gl_a - 0x00010000UL;      /* low half 0x0000: borrow must not appear */
}

static unsigned long sub_long_k2(unsigned long a)
{
    gl_a = a;
    return gl_a - 0x0001ffffUL;      /* low half 0xffff: borrow from bit 16 */
}

/* 16-bit subtract, subtrahend reaching BC (a-b, not b-a). */
static unsigned int sub_word_bc(unsigned int a, unsigned int b)
{
    gw_a = a; gw_b = b;
    return gw_a - gw_b;
}

/* The plainest 16-bit shape: two parameters and nothing else live, so the
 * allocator leaves BC free and the DE->BC staging actually fires. Operands are
 * asymmetric, so swapping them (DSUB is HL-BC and subtraction does not
 * commute) changes the value rather than just its sign. */
static unsigned int sub_word_plain(unsigned int a, unsigned int b)
{
    return (unsigned int)(a - b);
}

/* Same shape with the difference consumed, so the result cannot be confused
 * with either operand. */
static unsigned int sub_word_mix(unsigned int a, unsigned int b)
{
    return (unsigned int)((unsigned int)(a - b) ^ 0x1234u);
}

/* Global minus parameter — pins which operand reaches BC. */
static unsigned int sub_word_gp(unsigned int a)
{
    gw_a = 0x4000u;
    return (unsigned int)(gw_a - a);
}

/* 16-bit subtract with other values live across it, so a wrong BC clobber
 * corrupts the result rather than passing unnoticed. This one must DECLINE the
 * DE->BC staging: BC holds the minuend here, and taking it would corrupt it. */
static unsigned int sub_word_de(unsigned int a, unsigned int b, unsigned int c)
{
    unsigned int d = (unsigned int)(a + c);
    unsigned int e = (unsigned int)(b ^ 0x5555u);
    unsigned int r = (unsigned int)(a - b);
    return (unsigned int)(r + d + e);
}

/* A loop counter that wants a BC home, with a subtract in the body: the DE
 * staging must stay out of this function. */
static unsigned int sub_word_home(unsigned int n, unsigned int k)
{
    unsigned int i, s = 0;
    for (i = 0; i < n; i++)
        s = (unsigned int)(s + (unsigned int)(k - i));
    return s;
}

/* Borrow out of a subtract feeding a following subtract, to catch a carry that
 * is clobbered between the halves. */
static unsigned long chain(unsigned long a, unsigned long b, unsigned long c)
{
    g_acc = a - b;
    g_acc = g_acc - c;
    return g_acc;
}

void test_dsub(void)
{
    /* low-half borrow, high half decremented */
    assertEqual(sub_long(0x00010000UL, 0x00000001UL), 0x0000ffffUL);
    /* no borrow at all */
    assertEqual(sub_long(0x12345678UL, 0x00001111UL), 0x12344567UL);
    /* borrow out of the whole value (unsigned wrap) */
    assertEqual(sub_long(0x00000000UL, 0x00000001UL), 0xffffffffUL);
    /* equal operands: zero, no borrow */
    assertEqual(sub_long(0xdeadbeefUL, 0xdeadbeefUL), 0x00000000UL);
    /* high-half-only difference */
    assertEqual(sub_long(0xffff0000UL, 0x00010000UL), 0xfffe0000UL);

    assertEqual(sub_long_k(0x00025678UL),  0x00015678UL);
    assertEqual(sub_long_k2(0x00025678UL), 0x00005679UL);
    assertEqual(sub_long_k2(0x0001ffffUL), 0x00000000UL);

    assertEqual(sub_word_plain(0x1234u, 0x0111u), 0x1123u);
    assertEqual(sub_word_plain(0x0000u, 0x0001u), 0xffffu);
    assertEqual(sub_word_plain(0x0001u, 0x0001u), 0x0000u);
    assertEqual(sub_word_mix(0x1234u, 0x0111u),   0x0317u);
    assertEqual(sub_word_gp(0x0001u),             0x3fffu);
    assertEqual(sub_word_gp(0x8000u),             0xc000u);

    assertEqual(sub_word_bc(0x1234u, 0x0234u), 0x1000u);
    assertEqual(sub_word_bc(0x0000u, 0x0001u), 0xffffu);
    assertEqual(sub_word_bc(0x8000u, 0x8000u), 0x0000u);

    /* r=0x1234-0x0111=0x1123, d=0x1234+0x7=0x123b, e=0x0111^0x5555=0x5444 */
    assertEqual(sub_word_de(0x1234u, 0x0111u, 0x0007u), 0x77a2u);
    /* r wraps to 0xffff, d=0, e=0x5554 */
    assertEqual(sub_word_de(0x0000u, 0x0001u, 0x0000u), 0x5553u);

    /* k-i summed for i in 0..4: 100+99+98+97+96 */
    assertEqual(sub_word_home(5u, 100u), 490u);
    assertEqual(sub_word_home(0u, 100u), 0u);
    /* wraps through zero: 1 + 0 + 0xffff + 0xfffe */
    assertEqual(sub_word_home(4u, 1u), 0xfffeu);

    assertEqual(chain(0x00020000UL, 0x00000001UL, 0x00000001UL), 0x0001fffeUL);
    assertEqual(chain(0x00000001UL, 0x00000001UL, 0x00000001UL), 0xffffffffUL);
    assertEqual(g_acc, 0xffffffffUL);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 DSUB subtract lowering");
    suite_add_test(test_dsub);
    return suite_run();
}
