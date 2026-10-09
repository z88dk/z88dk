/* [switch-chain] A small word switch is a compare chain on HL instead of
 * `call l_case` + table: HL steps down through the sorted case values
 * (`dec hl`, `inc hl` or `ld de,-d; add hl,de`) and each case is a zero test.
 *
 *  - consec    0, 1, 2: three `dec hl` steps (the test.c suite_run shape).
 *  - signedv   -3, -1, 4: negative values, an `inc hl` step and an add.
 *  - sparse    100, 1000: large steps, one fall-through.
 *  - single    one case.
 *  - noncase   values next to every case value, and 0x7fff / 0x8000.
 *
 * Every CPU builds it. _keep runs the opt-out.
 */
#include "test.h"

static int consec(int v)
{
    int r = 0;

    switch (v) {
    case 0: r = 10; break;
    case 1: r = 11; break;
    case 2: r = 12; break;
    default: r = -1;
    }
    return r;
}

static int signedv(int v)
{
    switch (v) {
    case -3: return 3;
    case -1: return 1;
    case 4: return 4;
    }
    return 0;
}

static int sparse(unsigned v)
{
    int r = 0;

    switch (v) {
    case 100: r += 1;      /* falls through */
    case 1000: r += 2; break;
    default: r = 9;
    }
    return r;
}

static int single(int v)
{
    switch (v) {
    case 7: return 70;
    }
    return 0;
}

static void test_consec(void)
{
    Assert(consec(0) == 10, "0");
    Assert(consec(1) == 11, "1");
    Assert(consec(2) == 12, "2");
    Assert(consec(3) == -1, "3");
    Assert(consec(-1) == -1, "-1");
    Assert(consec(256) == -1, "256");
}

static void test_signedv(void)
{
    Assert(signedv(-3) == 3, "-3");
    Assert(signedv(-1) == 1, "-1");
    Assert(signedv(4) == 4, "4");
    Assert(signedv(-2) == 0, "-2");
    Assert(signedv(-4) == 0, "-4");
    Assert(signedv(0) == 0, "0");
    Assert(signedv(3) == 0, "3");
    Assert(signedv(5) == 0, "5");
    Assert(signedv(0x7fff) == 0, "0x7fff");
    Assert(signedv((int)0x8000) == 0, "0x8000");
}

static void test_sparse(void)
{
    Assert(sparse(100) == 3, "100 falls through");
    Assert(sparse(1000) == 2, "1000");
    Assert(sparse(99) == 9, "99");
    Assert(sparse(101) == 9, "101");
    Assert(sparse(999) == 9, "999");
    Assert(sparse(1001) == 9, "1001");
    Assert(sparse(0) == 9, "0");
}

static void test_single(void)
{
    Assert(single(7) == 70, "7");
    Assert(single(6) == 0, "6");
    Assert(single(8) == 0, "8");
}

int suite_switchchain(void)
{
    suite_setup("switch-chain");
    suite_add_test(test_consec);
    suite_add_test(test_signedv);
    suite_add_test(test_sparse);
    suite_add_test(test_single);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_switchchain();
    exit(res);
}
