/* Float correctness in the f48-double + _Float16 config (build -lmath48
   --math16, sp mode). Duplicates the acc-double and f16 mixed-int tests AND
   adds the CROSS-TIER f16<->double conversions (l_f48_f16tof / l_f48_ftof16),
   which only this config can link+run (the ieee suite makes double == f32).
   One case per function so frame layouts don't interact. */
#include "test.h"

double   g;
_Float16 g16;

/* --- acc double (f48) mixed int --- */
static int d_mul(void){ double d = 4.0; return (int)(3 * d) + (int)(d * 5); }   /* 32 */
static int d_div(void){ double d = 4.0; return (int)(d / 2) + (int)(40 / d); }  /* 12 */
static int d_char(void){ char c = 6; double d = 4.0; return (int)(c * d); }     /* 24 */
static int d_long(void){ long l = 100; double d = 4.0; return (int)(l * d); }   /* 400 */
static int d_cmp(void){ double d = 4.0; return (d > 3) + (3 < d) + (d == 4); }  /* 3 */
static int d_glob(int i){ g = i; return (int)g; }
static double d_ret(int i){ return i; }
static int d_caddmul(void){ double d = 10.0; d += 5; d *= 2; return (int)d; }   /* 30 */
static int d_inc(void){ double d = 5.0; d++; ++d; --d; return (int)d; }          /* 6 */

/* --- f16 mixed int --- */
static int f_mul(void){ _Float16 f = 4; return (int)(3 * f) + (int)(f * 5); }   /* 32 */
static int f_div(void){ _Float16 f = 4; return (int)(f / 2) + (int)(40 / f); }  /* 12 */
static int f_cmp(void){ _Float16 f = 4; return (f > 3) + (3 < f); }             /* 2 */
static int f_glob(int i){ g16 = i; return (int)g16; }
static _Float16 f_ret(int i){ return i; }
static int f_caddmul(void){ _Float16 f = 10; f += 5; f *= 2; return (int)f; }   /* 30 */
static int f_inc(void){ _Float16 f = 5; f++; ++f; --f; return (int)f; }          /* 6 */

/* --- cross-tier f16 <-> double --- */
static int f16_to_d(void){ _Float16 a = (_Float16)6; double d = a; return (int)d; }  /* 6 */
static int d_to_f16(void){ double d = 7.0; _Float16 a = d; return (int)a; }          /* 7 */
static _Float16 f16xd(_Float16 a){ return a * g; }   /* f16*double->double->f16 */
static int f16xd_use(void){ g = 5.0; return (int)f16xd((_Float16)4); }               /* 20 */
static int f16_cmp_d(_Float16 a){ return (a == g) + (a < g); }   /* f16 vs double compare */
static int f16_cmp_use(void){ g = 4.0; return f16_cmp_d((_Float16)4) + f16_cmp_d((_Float16)3); }/*1+0 +0+1=2*/

static void test_double(void)
{
    assertEqual(d_mul(), 32); assertEqual(d_div(), 12); assertEqual(d_char(), 24);
    assertEqual(d_long(), 400); assertEqual(d_cmp(), 3);
    assertEqual(d_glob(9), 9); assertEqual((int)d_ret(11), 11);
    assertEqual(d_caddmul(), 30); assertEqual(d_inc(), 6);
}
static void test_f16(void)
{
    assertEqual(f_mul(), 32); assertEqual(f_div(), 12); assertEqual(f_cmp(), 2);
    assertEqual(f_glob(9), 9); assertEqual((int)f_ret(11), 11);
    assertEqual(f_caddmul(), 30); assertEqual(f_inc(), 6);
}
static void test_cross(void)
{
    assertEqual(f16_to_d(), 6); assertEqual(d_to_f16(), 7);
    assertEqual(f16xd_use(), 20); assertEqual(f16_cmp_use(), 2);
}
int main(void)
{
    suite_setup("fp-f48f16");
    suite_add_test(test_double);
    suite_add_test(test_f16);
    suite_add_test(test_cross);
    return suite_run();
}
