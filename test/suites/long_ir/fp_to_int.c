/* Implicit float/double -> integer conversions. The front end leaves the
 * conversion to codegen; ir_build only had the int->float direction
 * (coerce_int_to_float_kind), so `int i = dbl;`, `return dbl;` from an int
 * function, and `arr[k] = dbl;` / `g = dbl;` fell into the integer
 * width-coercion and emitted a plain CONV_TRUNC of the 6-byte double's raw
 * bytes — a bail at 6->1, garbage at 6->2/4. Fixed by coerce_float_to_int_kind
 * (init/return) + an emit_acc_to_int step in the store path, matching the
 * explicit (int)dbl cast. This is umchess main's `b[K] = (double expr)`.
 *
 * Positive values only: the f2sint helper floors negatives (-42.7 -> -43),
 * a pre-existing lib rounding quirk shared with the explicit cast — not the
 * subject here. The double->double store guards a regression (deriving the
 * store kind from the folded member ADDRESS wrongly ifix'd it to int).
 * Needs the math lib; own binary (long_ir.c at the MSX 64K ceiling). */
#include "test.h"

double gd = 42.7;
char  acb[4]; int aib[4]; long alb[4];
char  ggc; int ggi; long ggl;
struct sdm { int pad; double d; } gsm;

static char i_d2c(double x) { char r = x; return r; }     /* init   double->char */
static int  i_d2i(double x) { int  r = x; return r; }     /* init   double->int  */
static long i_d2l(double x) { long r = x; return r; }     /* init   double->long */
static int  r_d2i(double x) { return x; }                 /* return double->int  */
static long r_d2l(double x) { return x; }                 /* return double->long */
static void s_ac(int k) { acb[k] = gd; }                  /* store  arr char     */
static void s_al(int k) { alb[k] = 100000.5; }            /* store  arr long     */
static void s_gc(void)  { ggc = gd; }                     /* store  glob char    */
static void s_gl(void)  { ggl = 100000.5; }               /* store  glob long    */
static double s_member(double a) { gsm.d = a; return gsm.d; } /* double->double member (no convert) */

static void test_fp_to_int(void)
{
    Assert(i_d2c(gd) == 42,        "init double->char");
    Assert(i_d2i(gd) == 42,        "init double->int");
    Assert(i_d2l(100000.5) == 100000L, "init double->long");
    Assert(r_d2i(gd) == 42,        "return double->int");
    Assert(r_d2l(100000.5) == 100000L, "return double->long");
    s_ac(1); Assert(acb[1] == 42,  "store double->char[]");
    s_al(1); Assert(alb[1] == 100000L, "store double->long[]");
    s_gc();  Assert(ggc == 42,      "store double->char global");
    s_gl();  Assert(ggl == 100000L, "store double->long global");
    /* double member store must NOT convert to int (regression guard) */
    Assert((int)s_member(42.0) == 42, "double->double member store unchanged");
}

int main(int argc, char *argv[])
{
    suite_setup("implicit float->integer conversions");
    suite_add_test(test_fp_to_int);
    return suite_run();
}
