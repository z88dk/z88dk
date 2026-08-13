/* Constant-multiply strength reduction: x*C is rewritten to shifts + one
   add/sub when C decomposes into <=2 power-of-two terms — either 2^a+2^b
   (two set bits: 3,5,6,9,10,12,17,20,...) or a run of consecutive 1-bits
   2^a-2^b (7,14,15,...). Other constants (e.g. 11) keep the l_mult /
   l_long_mult helper. On targets with a hardware multiply (Rabbit `mul`,
   IR_FEAT_FAST_MULT) every constant keeps the helper — the value is the
   same either way, so this test is CPU-agnostic.

   Globals defeat const-folding so the multiply survives to the IR builder.
   Split into its own binary because long_ir.c is at the MSX 64K ceiling. */
#include "test.h"

static int      cm_i;
static unsigned cm_u;
static long     cm_l;

static void test_int_const_mult(void)
{
    cm_i = 7;
    assertEqual(cm_i * 3,   21);
    assertEqual(cm_i * 5,   35);
    assertEqual(cm_i * 6,   42);
    assertEqual(cm_i * 7,   49);     /* run → shift+sub */
    assertEqual(cm_i * 9,   63);
    assertEqual(cm_i * 10,  70);
    assertEqual(cm_i * 11,  77);     /* not decomposable → helper */
    assertEqual(cm_i * 12,  84);
    assertEqual(cm_i * 15,  105);    /* run → shift+sub */
    assertEqual(cm_i * 100, 700);
    cm_i = -3;
    assertEqual(cm_i * 7,   -21);    /* signed low bits */
    assertEqual(cm_i * 10,  -30);
}

static void test_unsigned_const_mult(void)
{
    cm_u = 13000u;
    assertEqual((int)(cm_u * 5u), (int)65000u);   /* 52000+13000, no overflow trap */
    assertEqual((int)(cm_u * 3u), (int)39000u);
    /* Dense high constant (an LCG multiplier): hi_bit+pop = 21, inlined as the
       Horner shift-add chain for width-2 (was l_mult below the old flat gate). */
    cm_u = 7u;
    assertEqual((int)(cm_u * 25173u & 0xffffu), (int)(176211u & 0xffffu));
    cm_u = 123u;
    assertEqual((int)(cm_u * 25173u & 0xffffu), (int)(3096279u & 0xffffu));
}

static void test_long_const_mult(void)
{
    cm_l = 100000L;
    Assert(cm_l * 3  == 300000L,  "long x*3");
    Assert(cm_l * 10 == 1000000L, "long x*10");
    Assert(cm_l * 7  == 700000L,  "long x*7 (run/sub)");
    Assert(cm_l * 6  == 600000L,  "long x*6");
}

int main(int argc, char *argv[])
{
    suite_setup("const-multiply strength reduction");
    suite_add_test(test_int_const_mult);
    suite_add_test(test_unsigned_const_mult);
    suite_add_test(test_long_const_mult);
    return suite_run();
}
