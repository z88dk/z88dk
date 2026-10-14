/* fabs and fabsf16 clear the sign bit in line for the IEEE and MBF 32-bit
 * formats and for _Float16; other arguments and formats call the library.
 * Build with --math32 (HAVE_F16 adds --math16) or --math-mbf32. */
#include "test.h"
#include <math.h>

static volatile double vd;

static double ab(double x)            { return fabs(x); }
static double ab_neg(double x)        { return fabs(-x); }
static double ab_sum(double x, double y) { return fabs(x) + fabs(y); }
static int    ab_int(void)            { return (int)fabs(-7); }
static int    ab_conv(int i)          { return (int)fabs(i); }
static double ab_lit(void)            { return fabs(-2.5); }
static int    ab_cmp(double x)        { return fabs(x) < 1.0; }
static double ab_twice(double x)      { return fabs(fabs(x)); }
static double ab_mem(double *p)       { return fabs(*p); }
static double ab_live(double x, double y) { double a = fabs(x); vd = y; return a * y; }
static int    sb(double x)            { return signbit(x); }
static int    sb_cmp(double x, double y) { return signbit(x) != signbit(y); }
#ifdef HAVE_F16
static _Float16 h_ab(_Float16 x)      { return fabsf16(x); }
#endif

static void test_fabsin(void)
{
    double d = -3.5;
    assertEqual((int)(ab(-3.5) * 2), 7);
    assertEqual((int)(ab(3.5) * 2), 7);
    assertEqual((int)(ab(0.0) * 2), 0);
    assertEqual((int)(ab_neg(4.0) * 2), 8);
    assertEqual((int)(ab_sum(-1.5, -2.5)), 4);
    assertEqual(ab_int(), 7);
    assertEqual(ab_conv(-9), 9);
    assertEqual((int)(ab_lit() * 2), 5);
    assertEqual(ab_cmp(-0.5), 1);
    assertEqual(ab_cmp(-1.5), 0);
    assertEqual((int)(ab_twice(-6.0)), 6);
    assertEqual((int)(ab_mem(&d) * 2), 7);
    assertEqual((int)(ab_live(-2.0, 3.0)), 6);
    assertEqual(sb(-1.5) != 0, 1);
    assertEqual(sb(1.5) != 0, 0);
    assertEqual(sb(0.0) != 0, 0);
    assertEqual(sb_cmp(-1.0, 2.0), 1);
    assertEqual(sb_cmp(-1.0, -2.0), 0);
#ifdef HAVE_F16
    assertEqual((int)(h_ab(-5.0) * 2), 10);
    assertEqual((int)(h_ab(5.0) * 2), 10);
#endif
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("fabs inline");
    suite_add_test(test_fabsin);
    return suite_run();
}
