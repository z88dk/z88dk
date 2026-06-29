/* Register-tier float (f16 + IEEE-32) mixed int correctness — build with
   -fp-mode=ieee --math16 --math32 so both helper sets link. Covers
   arithmetic, comparison, assignment, initialisation and return; the int↔float
   conversions go through ir_build (build_operand_as_float_reg /
   coerce_int_to_float_kind). Natural int init now works. One case per fn. */
#include "test.h"

_Float16 g16;
double    g32;   /* ieee → IEEE-32 register tier */

/* --- f16 --- */
static int f16_mul(void){ _Float16 f = 4; return (int)(3 * f) + (int)(f * 5); }   /* 12+20 */
static int f16_div(void){ _Float16 f = 4; return (int)(f / 2) + (int)(40 / f); }  /* 2+10 */
static int f16_addsub(void){ _Float16 f = 4; return (int)(3 + f) + (int)(f - 1); }/* 7+3 */
static int f16_char(void){ char c = 6; _Float16 f = 4; return (int)(c * f); }     /* 24 */
static int f16_long(void){ long l = 100; _Float16 f = 4; return (int)(l * f); }   /* 400 */
static int f16_cmp(void){ _Float16 f = 4; return (f > 3) + (3 < f); }             /* 2 */
static int f16_glob(int i){ g16 = i; return (int)g16; }
static _Float16 f16_ret(int i){ return i; }
static int f16_caddmul(void){ _Float16 f = 10; f += 5; f *= 2; return (int)f; }   /* 30 */
static int f16_inc(void){ _Float16 f = 5; f++; ++f; --f; return (int)f; }          /* 6 */

/* --- f32 (double under ieee) --- */
static int f32_mul(void){ double d = 4; return (int)(3 * d) + (int)(d / 2); }     /* 12+2 */
static int f32_long(void){ long l = 100; double d = 4; return (int)(l * d); }     /* 400 */
static int f32_cmp(void){ double d = 4; return (d > 3) + (d == 4); }              /* 2 */
static int f32_glob(int i){ g32 = i; return (int)g32; }
static double f32_ret(int i){ return i; }
static int f32_caddmul(void){ double d = 10; d += 5; d *= 2; return (int)d; }     /* 30 */
static int f32_inc(void){ double d = 5; d++; ++d; --d; return (int)d; }            /* 6 */

static void test_f16(void)
{
    assertEqual(f16_mul(), 32); assertEqual(f16_div(), 12);
    assertEqual(f16_addsub(), 10); assertEqual(f16_char(), 24);
    assertEqual(f16_long(), 400); assertEqual(f16_cmp(), 2);
    assertEqual(f16_glob(9), 9); assertEqual((int)f16_ret(11), 11);
    assertEqual(f16_caddmul(), 30); assertEqual(f16_inc(), 6);
}
static void test_f32(void)
{
    assertEqual(f32_mul(), 14); assertEqual(f32_long(), 400);
    assertEqual(f32_cmp(), 2);
    assertEqual(f32_glob(9), 9); assertEqual((int)f32_ret(11), 11);
    assertEqual(f32_caddmul(), 30); assertEqual(f32_inc(), 6);
}
int main(void){ suite_setup("fp-reg"); suite_add_test(test_f16); suite_add_test(test_f32); return suite_run(); }
