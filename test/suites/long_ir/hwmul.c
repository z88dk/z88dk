/* Native hardware multiply (IR_MUL). build_muldiv_integer inlines the CPU
   multiply instead of calling l_mult on:
     kc160      : mul hl / muls hl (8x8 char), mul de,hl (16x16 int)
     z180/ez80  : mlt (unsigned 8x8 char only; signed char keeps l_mult)
     z80n       : mul de (unsigned 8x8 char only)
   On z80/8080/8085/gbz80/rabbit this file just exercises l_mult — the values
   are identical, so the same expectations hold everywhere (CPU-agnostic test).

   Globals defeat const-folding so the multiply survives to the IR builder.
   Products are checked against 16-bit int / unsigned semantics (z88dk int is
   16-bit: a >32767 signed product wraps, so those are checked as unsigned). */
#include "test.h"

static unsigned char ua, ub;
static signed char   sa, sb;
static unsigned int  ia, ib;
static int           si, sj;

static void test_uchar_mult(void)
{
    unsigned up; int p;
    ua = 200; ub = 200; up = ua * ub; Assert(up == 40000u, "200u*200u");
    ua = 13;  ub = 17;  p  = ua * ub; Assert(p  == 221,    "13u*17u");
    ua = 17;  ub = 15;  p  = ua * ub; Assert(p  == 255,    "17u*15u");
    ua = 255; ub = 255; up = ua * ub; Assert(up == 65025u, "255u*255u");
    ua = 7;   ub = 0;   p  = ua * ub; Assert(p  == 0,      "7u*0u");
}

static void test_schar_mult(void)
{
    int p;
    sa = -100; sb = 7;  p = sa * sb; Assert(p == -700, "-100s*7s");
    sa = -100; sb = -9; p = sa * sb; Assert(p == 900,  "-100s*-9s");
    sa = 100;  sb = -3; p = sa * sb; Assert(p == -300, "100s*-3s");
    sa = -128; sb = -1; p = sa * sb; Assert(p == 128,  "-128s*-1s");
    sa = 12;   sb = 10; p = sa * sb; Assert(p == 120,  "12s*10s");
}

static void test_mixed_mult(void)
{
    int p;
    ua = 250; sb = -2; p = ua * sb; Assert(p == -500, "250u*-2s");
    sa = -3;  ub = 100; p = sa * ub; Assert(p == -300, "-3s*100u");
}

static void test_int_mult(void)
{
    unsigned up; int p;
    ia = 1000; ib = 50; up = ia * ib; Assert(up == 50000u,  "1000*50 int");
    si = -123; sj = 100; p = si * sj; Assert(p == -12300,   "-123*100 int");
    ia = 200;  ib = 200; up = ia * ib; Assert(up == 40000u, "200*200 uint");
}

int main(int argc, char *argv[])
{
    suite_setup("hardware multiply");
    suite_add_test(test_uchar_mult);
    suite_add_test(test_schar_mult);
    suite_add_test(test_mixed_mult);
    suite_add_test(test_int_mult);
    return suite_run();
}
