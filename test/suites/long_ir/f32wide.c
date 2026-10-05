/* [reg-int-literal / hcall-commit / remat-imm32 / f32-prepush] Register-tier
 * floats (4-byte IEEE / MBF in DEHL, _Float16 in HL): an int converted from a
 * float and only passed on is not stored, an integer literal operand is a
 * float constant rebuilt at its helper call, and the operand a float helper
 * takes on the stack is pushed when computed, across balanced helper calls in
 * between. Build with -fp-mode=ieee --math32 (or --math-mbf32), plus --math16
 * for the _Float16 half (HAVE_F16). */
#include "test.h"
#include <stdlib.h>

static int gt0;
static int ga = 7;
static float gf;

static int take(int x) { return x + 1; }
static float sqf(float x) { return x * x; }
static int ival(void) { return ga * 3; }

static void c_store(float t) { gt0 = (int)t; }
static int c_ret(float t) { return (int)(t * 2) + 1; }
static int c_arg(float t) { return take((int)(t * 2)); }
static int c_twice(float t) { int i = (int)t; return i * i + i; }
static float c_call(void) { return (float)ival() + 0.5f; }

static float l_right(float a) { return a * 2 - 3; }
static float l_left(float a) { return 10 - a * 2; }
static float l_div(float a) { return 100 / (a + 1); }
static float l_cast(void) { return (float)RAND_MAX / 4; }

static float p_sub(float a, float b) { return a * 2 - b * 3; }
static float p_nest(float a, float b, float c, float d, float e, float g)
{ return (a * b - c * d) / (e - g); }
static float p_call(float a, float b) { return a * 3 - sqf(b + 1); }
static float p_deep(float a, float b) { return a - (b - (a - (b - 1))); }
static int p_cmp(float a, float b) { return a * 2 < sqf(b) - 1; }
static void p_store(float a, float b) { gf = (a + 1) / (b - 1); }

static void test_f32wide(void)
{
    c_store(12.75f); assertEqual(gt0, 12);
    assertEqual(c_ret(4.25f), 9);
    assertEqual(c_arg(4.25f), 9);
    assertEqual(c_twice(5.5f), 30);
    assertEqual((int)(c_call() * 2), 43);
    assertEqual((int)l_right(5), 7);
    assertEqual((int)l_left(3), 4);
    assertEqual((int)l_div(3), 25);
    assertEqual((int)l_cast(), 8191);
    assertEqual((int)p_sub(6, 2), 6);
    assertEqual((int)p_nest(3, 4, 2, 5, 4, 3), 2);
    assertEqual((int)p_call(5, 2), 6);
    assertEqual((int)p_deep(10, 4), 13);
    assertEqual(p_cmp(3, 3), 1); assertEqual(p_cmp(4, 2), 0);
    p_store(5, 4); assertEqual((int)gf, 2);
}

#ifdef HAVE_F16
static int h_conv(_Float16 t) { return (int)(t * 2) + 1; }
static _Float16 h_lit(_Float16 a) { return a * 2 - 3; }
static _Float16 h_left(_Float16 a) { return 10 - a * 2; }
static _Float16 h_nest(_Float16 a, _Float16 b, _Float16 c, _Float16 d)
{ return (a * b - c * d) / (a - c); }

static void test_f16wide(void)
{
    assertEqual(h_conv((_Float16)4.25), 9);
    assertEqual((int)h_lit((_Float16)5), 7);
    assertEqual((int)h_left((_Float16)3), 4);
    assertEqual((int)h_nest((_Float16)4, (_Float16)3, (_Float16)2, (_Float16)2), 4);
}
#endif

int main(int argc, char *argv[])
{
    suite_setup("f32wide");
    suite_add_test(test_f32wide);
#ifdef HAVE_F16
    suite_add_test(test_f16wide);
#endif
    return suite_run();
}
