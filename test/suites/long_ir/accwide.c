/* [acc-drop-wide / acc-int-literal / acc-pool-operand] Wide (6-byte double,
 * long long) results consumed straight from the accumulator, integer literals
 * as double and i64 pool constants on either side of a non-commutative op, and
 * a wide value pushed as a call argument from the accumulator. NO_DOUBLE builds
 * the long long half alone, for a target with no 5/6-byte double library. */
#include "test.h"

#ifndef NO_DOUBLE
static double gd;
#endif
static long long gl;

#ifndef NO_DOUBLE
static int cint(double d) { return (int)(d + 0.5); }
static double rnd_like(int a) { return a / (double)250; }
static double lit_left(int a) { return 1000 / (double)a; }
static double sub_both(double x) { return (10 - x) * (x - 4); }
static double half(double x) { return x / 2; }
static double twice_arg(double x) { return half(x * 6); }
static void store_g(double x) { gd = x * 3 + 1; }
static int cmp_lit(double x) { return x * 2 < 9; }
static double redef(double x) { x = x * 4; x = x - 1; return x; }
static double chain(int a, int b) { return (double)a / 8 * 3 - b / (double)4; }
static int gi = 3;
static long glg = 5;
static double f1(int a, double x, int b) { return a + x * 2 + b; }
static double f2(double x, int a, long c) { return x - a - c; }
static double f3(long c, int a, double x) { return x * c + a; }
static double f4(int a, double x, int b) __stdc { return a * 100 + x + b; }
static double fc(double x) __z88dk_fastcall { return x * 2; }
static double t1(double y) { return f1(gi, y * 4, gi + 1); }
static double t2(double y) { return f2(y + 1, gi * 2, glg + 1); }
static double t3(double y) { return f3(glg * 2, gi, y / 2); }
static double t4(double y) { return f4(gi, y - 1, gi); }
static double t6(double y) { return fc(y + 1); }
static int m_lt(double a, double b) { return a < b * 2; }
static int m_le(double a, double b) { return a <= b * 2; }
static int m_gt(double a, double b) { return a > b * 2; }
static int m_ge(double a, double b) { return a >= b * 2; }
static int m_pool(double b) { return 9 < b * 2; }
static double sq(double x) { return x * x; }
static int ga = 7;
static double p_nest(double a, double b, double c, double d, double e, double g)
{ return (a * b - c * d) / (e - g); }
static double p_call(double a, double b) { return a * 3 - sq(b + 1); }
static double p_int(double a, int i) { return a / 2 - (double)(i * ga + 1); }
static double p_deep(double a, double b) { return a - (b - (a - (b - 1))); }
static int p_cmp(double a, double b) { return a * 2 < sq(b) - 1; }

#endif

static long long ll_mul_sub(long long x) { return x * 10 - 7; }
static long long ll_lit_left(long long x) { return 100 / x; }
static long long ll_mod(long long x) { return x % 7; }
static long long ll_sub_left(long long x) { return 5 - x; }
static long long ll_and(long long x) { return x & 0xff; }
static long long ll_big(long long x) { return x + 0x100000000LL; }
static int ll_hi(long long x) { return (int)((x * 3) >> 32); }
static void ll_store(long long x) { gl = x * 1000 + 3; }
static long long l1(int a, long long x, int b) { return a + x * 2 + b; }
static long long lfc(long long x) __z88dk_fastcall { return x + 1; }
static int li = 3;
static long long lm_sub(long long a, long long b) { return a - b * 3; }
static int lm_lt(long long a, long long b) { return a < b * 2; }
static int lm_ge(long long a, long long b) { return a >= b * 2; }
static int lm_ult(unsigned long long a, unsigned long long b) { return a < b * 2; }
static int lm_uge(unsigned long long a, unsigned long long b) { return a >= b * 2; }
static long long lsq(long long x) { return x * x; }
static long long lp_nest(long long a, long long b, long long c, long long d, long long e, long long g)
{ return (a * b - c * d) / (e - g); }
static long long lp_call(long long a, long long b) { return a * 3 - lsq(b + 1); }
static long long lp_deep(long long a, long long b) { return a - (b - (a - (b - 1))); }
static int lp_cmp(long long a, long long b) { return a * 2 < lsq(b) - 1; }

#ifndef NO_DOUBLE
static void test_accwide_double(void)
{
    assertEqual(cint(2.25), 2);
    assertEqual(cint(7.0), 7);
    assertEqual(cint(-0.25), 0);
    assertEqual((int)(rnd_like(500) * 4), 8);
    assertEqual((int)lit_left(8), 125);
    assertEqual((int)lit_left(-4), -250);
    assertEqual((int)sub_both(6.0), 8);
    assertEqual((int)sub_both(12.0), -16);
    assertEqual((int)twice_arg(5.0), 15);
    store_g(2.5);
    assertEqual((int)(gd * 2), 17);
    assertEqual(cmp_lit(4.0), 1);
    assertEqual(cmp_lit(4.5), 0);
    assertEqual((int)redef(2.5), 9);
    assertEqual((int)(chain(16, 6) * 2), 9);
    assertEqual((int)t1(1.5), 19);
    assertEqual((int)t2(20), 9);
    assertEqual((int)t3(8), 43);
    assertEqual((int)t4(5.0), 307);
    assertEqual((int)t6(3.0), 8);
    assertEqual(m_lt(5, 3), 1); assertEqual(m_lt(6, 3), 0); assertEqual(m_lt(7, 3), 0);
    assertEqual(m_le(5, 3), 1); assertEqual(m_le(6, 3), 1); assertEqual(m_le(7, 3), 0);
    assertEqual(m_gt(5, 3), 0); assertEqual(m_gt(6, 3), 0); assertEqual(m_gt(7, 3), 1);
    assertEqual(m_ge(5, 3), 0); assertEqual(m_ge(6, 3), 1); assertEqual(m_ge(7, 3), 1);
    assertEqual(m_pool(4.5), 0); assertEqual(m_pool(5), 1);
    assertEqual((int)p_nest(3, 4, 2, 5, 4, 3), 2);
    assertEqual((int)p_call(5, 2), 6);
    assertEqual((int)p_int(10, 2), -10);
    assertEqual((int)p_deep(10, 4), 13);
    assertEqual(p_cmp(3, 3), 1); assertEqual(p_cmp(4, 2), 0);
}
#endif

static void test_accwide_i64(void)
{
    assertEqual((int)ll_mul_sub(5), 43);
    assertEqual((int)ll_mul_sub(-3), -37);
    assertEqual((int)ll_lit_left(7), 14);
    assertEqual((int)ll_lit_left(-30), -3);
    assertEqual((int)ll_mod(100), 2);
    assertEqual((int)ll_sub_left(9), -4);
    assertEqual((int)ll_and(0x1234), 0x34);
    assertEqual((int)(ll_big(5) >> 32), 1);
    assertEqual((int)ll_big(5), 5);
    assertEqual(ll_hi(0x80000000LL), 1);
    ll_store(70);
    assertEqual((int)(gl - 70000), 3);
    assertEqual((int)l1(li, (long long)7 * 3, li), 48);
    assertEqual((int)lfc((long long)li * 4), 13);
    assertEqual((int)lm_sub(10, 4), -2);
    assertEqual((int)lm_sub(-10, -4), 2);
    assertEqual((int)(lm_sub(0x100000000LL, 1) >> 32), 0);
    assertEqual(lm_lt(5, 3), 1); assertEqual(lm_lt(6, 3), 0); assertEqual(lm_lt(-7, -3), 1);
    assertEqual(lm_ge(5, 3), 0); assertEqual(lm_ge(6, 3), 1); assertEqual(lm_ge(-5, -3), 1);
    assertEqual(lm_ult(5, 3), 1); assertEqual(lm_ult(0xFFFFFFFFFFFFFFFFULL, 3), 0);
    assertEqual(lm_uge(5, 3), 0); assertEqual(lm_uge(0x8000000000000000ULL, 1), 1);
    assertEqual((int)lp_nest(3, 4, 2, 5, 4, 3), 2);
    assertEqual((int)lp_call(5, 2), 6);
    assertEqual((int)lp_deep(10, 4), 13);
    assertEqual(lp_cmp(3, 3), 1); assertEqual(lp_cmp(4, 2), 0);
}

int main(int argc, char *argv[])
{
    suite_setup("accwide");
#ifndef NO_DOUBLE
    suite_add_test(test_accwide_double);
#endif
    suite_add_test(test_accwide_i64);
    return suite_run();
}
