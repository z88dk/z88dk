/* Implicit REGISTER-tier float -> integer conversions: _Float16 and IEEE-32
 * `double` (-fp-mode=ieee --math16 --math32). The acc-tier sibling is
 * fp_to_int.c; this is the same set of shapes for the register tier, which
 * coerce_float_to_int_kind used to skip entirely.
 *
 * The acc tier survived by accident: a 5/6/8-byte double reaching the
 * integer width-coercion still hit CONV_TRUNC and looked wrong. A register
 * float is the SAME width as its integer destination (f16/int = 2, f32/long
 * = 4), so nothing tripped — `long l = pow(2,8);` stored the raw IEEE bit
 * pattern into l and no diagnostic fired. binary-trees then looped forever
 * on `for (i = 1; i <= iterations; i++)` with iterations = 1132462072.
 *
 * Fixed by routing the register tier through the same
 * l_f{16,32}_f2{s,u}{int,long} helpers the explicit (int)f cast already used.
 * Values are exact in both formats, so f16 and f32 agree. Unsigned
 * destinations above 32767 check the f2u* helper is picked over f2s*. */
#include "test.h"

_Float16 g16 = 42;
double   g32 = 42;            /* ieee -> IEEE-32 register tier */
double   gbig = 100000;
double   gu   = 40000;        /* > INT_MAX: needs f2uint, not f2sint */

char acb[4]; int aib[4]; long alb[4]; unsigned aub[4];
char ggc; int ggi; long ggl; unsigned ggu;
struct sdm { int pad; double d; } gsm;

/* --- initialiser: float -> integer local --- */
static char i_f2c(double x)      { char r = x;      return r; }
static int  i_f2i(double x)      { int  r = x;      return r; }
static long i_f2l(double x)      { long r = x;      return r; }
static unsigned i_f2u(double x)  { unsigned r = x;  return r; }
static int  i_h2i(_Float16 x)    { int  r = x;      return r; }
static long i_h2l(_Float16 x)    { long r = x;      return r; }

/* --- return: float -> integer return type --- */
static int      r_f2i(double x)   { return x; }
static long     r_f2l(double x)   { return x; }
static unsigned r_f2u(double x)   { return x; }
static int      r_h2i(_Float16 x) { return x; }

/* --- assignment to an already-declared integer local --- */
static long a_f2l(double x) { long r; r = x; return r; }
static int  a_h2i(_Float16 x) { int r; r = x; return r; }

/* --- store: float -> integer global / array element --- */
static void s_gc(void) { ggc = g32; }
static void s_gi(void) { ggi = g32; }
static void s_gl(void) { ggl = gbig; }
static void s_gu(void) { ggu = gu; }
static void s_ac(int k) { acb[k] = g32; }
static void s_ai(int k) { aib[k] = g16; }
static void s_al(int k) { alb[k] = gbig; }
static void s_au(int k) { aub[k] = gu; }

/* An arithmetic result assigned straight into an integer destination —
 * the conversion has to follow the l_f32_add, not the operand. */
static long a_expr(void) { long r; r = g32 + 1.0; return r; }

/* --- float arg to an integer parameter --- */
static int      p_i(int x)      { return x; }
static long     p_l(long x)     { return x; }
static unsigned p_u(unsigned x) { return x; }
static char     p_c(char x)     { return x; }

/* --- compound assign: integer lvalue, float rhs. C computes in the float
 * type, so `i = 1; i += 2.5` is 3 (via 3.5), not 1 + (int)2.5. --- */
static int  c_iadd(void)  { int i = 1;  i += g32; return i; }        /* 43  */
static int  c_isub(void)  { int i = 50; i -= g32; return i; }        /* 8   */
static int  c_imul(void)  { int i = 2;  i *= g32; return i; }        /* 84  */
static int  c_idiv(void)  { int i = 84; i /= g32; return i; }        /* 2   */
static long c_ladd(void)  { long l = 1; l += gbig; return l; }       /* 100001 */
static int  c_hadd(void)  { int i = 1;  i += g16; return i; }        /* 43  */
static int  c_gadd(void)  { ggi = 1; ggi += g32; return ggi; }       /* 43  */
/* f16 rhs: the arithmetic happens in _Float16, so keep the magnitudes
 * inside half precision (max 65504, 11-bit mantissa). */
static long c_glsub(void) { ggl = 100L; ggl -= g16; return ggl; }    /* 58  */
static unsigned c_uadd(void) { unsigned u = 20000; u += gu; return u; } /* 60000 */
static int  c_padd(void)  { int i = 1; int *p = &i; *p += g32; return i; } /* 43 */
static int  c_round(void) { int i = 1; i += 2.5; return i; }         /* 3, not 1+2 */

/* double -> double member store must NOT convert (regression guard). */
static double s_member(double a) { gsm.d = a; return gsm.d; }

static void test_fp_to_int_reg(void)
{
    Assert(i_f2c(g32) == 42,          "init f32->char");
    Assert(i_f2i(g32) == 42,          "init f32->int");
    Assert(i_f2l(gbig) == 100000L,    "init f32->long");
    Assert(i_f2u(gu) == 40000u,       "init f32->unsigned");
    Assert(i_h2i(g16) == 42,          "init f16->int");
    Assert(i_h2l(g16) == 42L,         "init f16->long");

    Assert(r_f2i(g32) == 42,          "return f32->int");
    Assert(r_f2l(gbig) == 100000L,    "return f32->long");
    Assert(r_f2u(gu) == 40000u,       "return f32->unsigned");
    Assert(r_h2i(g16) == 42,          "return f16->int");

    Assert(a_f2l(gbig) == 100000L,    "assign f32->long local");
    Assert(a_h2i(g16) == 42,          "assign f16->int local");

    s_gc(); Assert(ggc == 42,         "store f32->char global");
    s_gi(); Assert(ggi == 42,         "store f32->int global");
    s_gl(); Assert(ggl == 100000L,    "store f32->long global");
    s_gu(); Assert(ggu == 40000u,     "store f32->unsigned global");

    s_ac(1); Assert(acb[1] == 42,     "store f32->char[]");
    s_ai(1); Assert(aib[1] == 42,     "store f16->int[]");
    s_al(1); Assert(alb[1] == 100000L, "store f32->long[]");
    s_au(1); Assert(aub[1] == 40000u, "store f32->unsigned[]");

    Assert(a_expr() == 43L,           "assign f32 expression->long");

    Assert(p_i(g32) == 42,            "arg f32->int param");
    Assert(p_l(gbig) == 100000L,      "arg f32->long param");
    Assert(p_u(gu) == 40000u,         "arg f32->unsigned param");
    Assert(p_c(g32) == 42,            "arg f32->char param");
    Assert(p_i(g16) == 42,            "arg f16->int param");

    Assert(c_iadd() == 43,            "int += f32");
    Assert(c_isub() == 8,             "int -= f32");
    Assert(c_imul() == 84,            "int *= f32");
    Assert(c_idiv() == 2,             "int /= f32");
    Assert(c_ladd() == 100001L,       "long += f32");
    Assert(c_hadd() == 43,            "int += f16");
    Assert(c_gadd() == 43,            "global int += f32");
    Assert(c_glsub() == 58L,          "global long -= f16");
    Assert(c_uadd() == 60000u,        "unsigned += f32");
    Assert(c_padd() == 43,            "*intp += f32");
    Assert(c_round() == 3,            "int += 2.5 rounds in float, not int");

    Assert((int)s_member(42.0) == 42, "double->double member store unchanged");
}

int main(int argc, char *argv[])
{
    suite_setup("implicit register-float->integer conversions");
    suite_add_test(test_fp_to_int_reg);
    return suite_run();
}
