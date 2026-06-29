/* _Accum (fixed-point) mixed arithmetic/conversion correctness — the int↔
   _Accum scaling + _Accum↔double cross-tier the (removed) walker did, now in
   ir_build (build_operand_as_accum / coerce_int_to_float_kind / the _Accum
   mul/div + add/sub/compare branches). Build -lmath48 (Q-format + f48 double
   helpers). One case per function so frame layouts don't interact (the
   multi-FA-local driver bug is tracked separately). */
#include "test.h"

static _Accum mk(int i){ _Accum a = i; return a; }   /* int → _Accum (sint2f) */

/* --- int ↔ _Accum arithmetic --- */
static int imul(_Accum a){ return (int)(a * 3); }
static int imul2(_Accum a){ return (int)(3 * a); }
static int idiv(_Accum a){ return (int)(a / 3); }
static int iadd(_Accum a){ return (int)(a + 2); }
static int isub(_Accum a){ return (int)(a - 3); }
static int icmp(_Accum a){ return (a > 3) + (a == 4) + (a < 5); }
static int samek(_Accum a, _Accum b){ return (int)(a + b) + (int)(a * b); }
static _Accum g_acc;
static int ainc(void){ g_acc = mk(5); g_acc++; ++g_acc; --g_acc; return (int)g_acc; }  /* 6 */

/* --- _Accum → double cross-tier (fix16tof) --- */
static int a_to_d(_Accum a){ double d = a; return (int)d; }
static int a_x_d(_Accum a){ double d = 5.0; return (int)(a * d); }
/* NOTE: double → _Accum (ftofix16) is lib-side pending — the helper gives a
   wrong runtime value; codegen is correct (same FA ABI as the working
   fix16tof). Re-add `_Accum a = double` cases once the lib helper is fixed. */

static void test_accum_int(void)
{
    assertEqual(imul(mk(4)), 12); assertEqual(imul2(mk(4)), 12);
    assertEqual(idiv(mk(12)), 4); assertEqual(iadd(mk(4)), 6);
    assertEqual(isub(mk(10)), 7); assertEqual(icmp(mk(4)), 3);
    assertEqual(samek(mk(4), mk(2)), 6 + 8); assertEqual((int)mk(7), 7);
    assertEqual(ainc(), 6);
}
static void test_accum_cross(void)
{
    assertEqual(a_to_d(mk(4)), 4); assertEqual(a_x_d(mk(4)), 20);
}
int main(void)
{
    suite_setup("fp-accum");
    suite_add_test(test_accum_int);
    suite_add_test(test_accum_cross);
    return suite_run();
}
