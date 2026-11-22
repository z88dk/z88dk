/* Two half-float adds whose operands are folded constants. The lowerer
 * loads `b` into HL with `ld de,K; ex de,hl`, then copies it to DE before
 * loading `a`. copt rules that drop an `ex de,hl` ahead of two reloads
 * (#G2, #G3 and the generic pair) must not fire when the first reload reads
 * the swapped pair (`ld de,hl`, `ld hl,de`): here that turned 1+2^-5 into
 * 1+1.
 *
 * Built for 8085 and 8080 with math16, and for z80. mathstash_8085 builds
 * the math suite's math.c, which also covers the gen_hcall DE stash taking a
 * DE that holds a dead value.
 */
#include "test.h"

#ifdef __MATH_MATH16
#define FLOAT _Float16
#else
#define FLOAT float
#endif

static void test_edges(void)
{
#ifdef __MATH_MATH16
    union { FLOAT f; unsigned u; } a, b, r;
    static FLOAT vz;

    vz = (FLOAT)0.0;

    a.u = 0x3c00u;
    b.u = (unsigned)((15 - 5) << 10);
    r.f = a.f + b.f;
    Assert(r.u == 0x3c20u, "1+2^-5");
    b.u = (unsigned)((15 - 8) << 10);
    r.f = a.f + b.f;
    Assert(r.u == 0x3c04u, "1+2^-8");
    b.u = (unsigned)((15 - 10) << 10);
    r.f = a.f + b.f;
    Assert(r.u == 0x3c01u, "1+2^-10");
    Assert(vz == (FLOAT)0.0, "zero kept");
#endif
}

int suite_hcallstash(void)
{
    suite_setup("hcall-stash");
    suite_add_test(test_edges);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_hcallstash();
    exit(res);
}
