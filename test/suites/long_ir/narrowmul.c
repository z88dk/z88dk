/* Narrowing multiply (default-on; IR_NO_NARROW_MUL opts out): the fixed-point /
 * scaling idiom `(unsigned long)u16 * u16` lowers to the 16x16->32 helper
 * l_mulu_32_16x16 (dehl = hl * de) instead of widening both operands to 32 bits
 * for l_long_mult_u. The canonical helper dispatches to native hardware multiply
 * on z180/ez80/z80n/kc160/rabbit and the size/speed loop on z80; it is undefined
 * on 808x/gbz80, where the optimisation is CPU-guarded off (l_long_mult_u kept).
 *
 * Unsigned only — there is no signed 16x16->32 helper, so a signed operand
 * (`(long)(int)a * b`) must keep l_long_mult (`(unsigned long)a` of a negative
 * int is a large 32-bit value, not a u16). char operands zero-extend to u16.
 * The detection peels widening unsigned casts before the operands are built, so
 * side effects evaluate once. Checksums are host-verified and width-independent. */
#include "test.h"

/* keep these out of line (parameters) so the multiply isn't constant-folded */
static unsigned long nm_uu(unsigned int a, unsigned int b)  { return (unsigned long)a * b; }
static unsigned long nm_cc(unsigned char a, unsigned char b){ return (unsigned long)a * b; }
static unsigned int  nm_q88(unsigned int a, unsigned int b) { return (unsigned int)(((unsigned long)a * b) >> 8); }
static long          nm_ss(int a, int b)                    { return (long)a * b; }   /* NOT narrowed */
/* accumulating dot product in Q8.8 — the shift-narrow feeds an add each iter */
static unsigned int  nm_dot(const unsigned int *x, const unsigned int *c, int n)
{
    unsigned int acc = 0; int i;
    for (i = 0; i < n; i++)
        acc = (unsigned int)((acc + (unsigned int)(((unsigned long)x[i] * c[i]) >> 8)) & 0xffffu);
    return acc;
}

static void nm_run(void)
{
    Assert(nm_uu(200u, 300u)     == 60000UL,      "200*300");
    Assert(nm_uu(1000u, 1000u)   == 1000000UL,    "1000*1000 (>16 result)");
    Assert(nm_uu(65535u, 65535u) == 4294836225UL, "65535^2 full 32-bit");
    Assert(nm_uu(0u, 54321u)     == 0UL,          "0*x");
    Assert(nm_uu(1u, 65535u)     == 65535UL,      "1*x");

    Assert(nm_cc(17, 200)   == 3400UL,  "uchar 17*200");
    Assert(nm_cc(255, 255)  == 65025UL, "uchar 255^2");
    Assert(nm_cc(0, 255)    == 0UL,     "uchar 0*x");

    Assert(nm_q88(192u, 256u) == 192u, "Q8.8 192 * 1.0");
    Assert(nm_q88(384u, 128u) == 192u, "Q8.8 1.5 * 0.5");
    Assert(nm_q88(256u, 256u) == 256u, "Q8.8 1.0 * 1.0");

    Assert(nm_ss(-100, 7)        == -700L,      "signed -100*7 (l_long_mult)");
    Assert(nm_ss(-30000, -30000) == 900000000L, "signed big");
    Assert(nm_ss(30000, 20000)   == 600000000L, "signed pos");

    {
        static const unsigned int xs[4] = { 256u, 512u, 128u, 300u };  /* Q8.8: 1.0 2.0 0.5 ~1.17 */
        static const unsigned int cs[4] = { 128u, 64u, 256u, 200u };
        /* (256*128 + 512*64 + 128*256 + 300*200) >> 8 each, summed:
           128 + 128 + 128 + 234 = 618 */
        Assert(nm_dot(xs, cs, 4) == 618u, "Q8.8 dot");
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("narrowing multiply");
    suite_add_test(nm_run);
    return suite_run();
}
