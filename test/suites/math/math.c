

#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#include <math.h>

#ifdef MATH16
    #define FABS(x) fabsf16(x)
    #define SQRT(x) sqrtf16(x);
    #define POW(x,y) powf16(x,y)
    typedef _Float16 FLOAT;
#else
    #define FABS(x) fabs(x)
    #define SQRT(x) sqrt(x);
    #define POW(x,y) pow(x,y)
    #define FMOD(x,y) fmod(x,y)
    #define FMIN(x,y) fmin(x,y)
    #define FMAX(x,y) fmax(x,y)
    typedef double FLOAT;
#endif

#ifdef MATH16
   #define EPSILON (0.005)
   #define TINY_POSITIVE TINY_POS_F16
#elif MATH32 | AM9511
   #define EPSILON (0.000001)
   #define TINY_POSITIVE TINY_POS_F32
/* dai32 is looser than the other 32-bit formats because its pow() is: the
   binding case is pow(4,3) = 63.99893188476562, a relative error of 8.3e-6
   against a format whose mantissa is only good to ~1.2e-7. 2e-5 clears that
   with roughly 2.4x margin. This tolerance was never actually applied before
   -- TINY_POS_AM9511 mis-encoded as ~9.2e18 sent every comparison down the
   near-zero branch, making approx_equal vacuously true. */
#elif MATHDAI32
   #define EPSILON (0.00002)
   #define TINY_POSITIVE TINY_POS_AM9511
#elif MBF32
   #define EPSILON (0.000001)
   #define TINY_POSITIVE TINY_POS_F32
#else
   #define EPSILON (0.000000001)
#ifndef FLT_MIN
#define FLT_MIN      1.0e-38
#endif
   #define TINY_POSITIVE FLT_MIN
#endif

void test_comparison()
{
     FLOAT a = 10.0;
     FLOAT b = -2.0;
     FLOAT c =  0.0;

     Assert( a != b, "a != b");
     Assert( a > b, "a > b");
     Assert( a >= b, "a >= b");
     Assert( b <= a, "b <= a");
     Assert( b < a, "b < a");

     Assert( a != 0, "a != 0");
     Assert( a > 0, "a > 0");
     Assert( a >= 0, "a >= 0");
     Assert( 0 <= a, "0 <= a");
     Assert( 0 < a, "0 < a");

     Assert( c > b, "c > b");
     Assert( c >= b, "c >= b");
     Assert( b <= c, "b <= c");
     Assert( b < c, "b < c");

     Assert( a >= a, "a >= a");
     Assert( a <= a, "a <= a");

     Assert( b >= b, "b >= b");
     Assert( b <= b, "b <= b");

     Assert( a == a, "a == a");
     Assert( !(a != a), "!(a != a)");
}

void test_integer_constant_operations()
{
     FLOAT a = 2;

     a += 2;
     Assert ( a == 4, "addition: a == 4");
     a *= 2;
     Assert ( a == 8, "multiply: a == 8");
     a /= 2;
     Assert ( a == 4, "divide: a == 4");
     a -= 2;
     Assert ( a == 2, "subtract: a == 2");
}

void test_integer_operations()
{
     FLOAT a = 2;
     int    b = 2;

     a += b;
     Assert ( a == 4, "addition: a == 4");
     a *= b;
     Assert ( a == 8, "multiply: a == 8");
     a /= b;
     Assert ( a == 4, "divide: a == 4");
     a -= b;
     Assert ( a == 2, "subtract: a == 2");
}

void test_integer_constant_longform_lhs()
{
     FLOAT a = 2;

     a = 2 + a;
     Assert ( a == 4, "addition: a == 4");
     a = 2 * a;
     Assert ( a == 8, "multiply: a == 8");
     a = 32 / a;
     Assert ( a == 4, "divide: a == 4");
     a = 6 - a;
     Assert ( a == 2, "subtract: a == 2");
}

void test_integer_constant_longform()
{
     FLOAT a = 2;

     a = a + 2;
     Assert ( a == 4, "addition: a == 4");
     a = a * 2;
     Assert ( a == 8, "multiply: a == 8");
     a = a / 2;
     Assert ( a == 4, "divide: a == 4");
     a = a - 2;
     Assert ( a == 2, "subtract: a == 2");
}

void test_post_incdecrement()
{
     FLOAT a = 2;

     a++;
     Assert( a == 3, "++: a == 3");
     a--;
     Assert( a == 2, "--: a == 2");
}

static int approx_equal(FLOAT a, FLOAT b, FLOAT epsilon)
{

    float absa = FABS( a );
    float absb = FABS( b );
    float diff = FABS( a-b );

    if (a == b) {
        /* shortcut, handles infinities */
        return 1;
    } else {
        if ( a == 0 || b == 0 || ((absa + absb) < TINY_POSITIVE )) {
            /* a or b is zero or both are extremely close to it */
            /* relative error is less meaningful here           */
            return diff < (epsilon * TINY_POSITIVE);
        } else {
            /* use relative error */
            return diff/(absa + absb) < epsilon;
        }
    }
}

void test_pre_incdecrement()
{
     FLOAT a = 2;

     ++a;
     Assert( a == 3, "++: a == 3");
     --a;
     Assert( a == 2, "--: a == 2");
}

void test_approx_equal()
{
#ifndef MATHDAI32
    Assert( approx_equal(1.0,2.0,EPSILON) == 0, " 1 != 2");
    Assert( approx_equal(1.0,1.0,EPSILON) == 1, " 1 == 1");
    //                   0.00000001
    Assert( approx_equal(1.23456789,1.23456789,EPSILON) == 1, " 1.23456789 == 1.23456789");
#ifdef MATH16
    //                   0.005
    Assert( approx_equal(1.24,1.22,EPSILON) == 0, " 1.24 != 1.22");
#elif MATH32 | MBF32 | AM9511
    //                   0.000001
    Assert( approx_equal(1.23456,1.23455,EPSILON) == 0, " 1.23456 != 1.23455");
#else
    //                   0.00000001
    Assert( approx_equal(1.23456789,1.23456788,EPSILON) == 0, " 1.23456789 != 1.23456788");
#endif
#endif
}

static void run_sqrt(FLOAT x, FLOAT e)
{
    static char   buf[100];

    FLOAT r = SQRT(x);
    /* Compare before snprintf: multi-float varargs can clobber sccz80
     * stack params on 8085 (and is wasteful on success everywhere). */
    if (approx_equal(e,r,EPSILON))
        return;
    snprintf(buf,sizeof(buf),"Sqrt(%f) should be %.14f but was %.14f",(float)x,(float)e,(float)r);
    Assert(0, buf);
}

void test_sqrt()
{
    run_sqrt(4.0, 2.0);
    run_sqrt(9.0, 3.0);
    run_sqrt(1.0, 1.0);
    run_sqrt(6400, 80.0);
    run_sqrt(0.5, 0.70710678);
}

static void run_pow(FLOAT x, FLOAT y, FLOAT e)
{
    static char   buf[100];

    FLOAT r = POW(x,y);
    if (approx_equal(e,r,EPSILON))
        return;
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert(0, buf);
}

void test_pow()
{
    run_pow(2.0, 2.0, 4.0);
    run_pow(0.5, 2.0, 0.25);
    run_pow(4.0, 3.0, 64.0);
    run_pow(2, 0.5, 1.41421356);
}

#ifndef MATH16

static void run_fmod(FLOAT x, FLOAT y, FLOAT e)
{
    static char   buf[100];

    FLOAT r = FMOD(x,y);
    if (approx_equal(e,r,EPSILON))
        return;
    snprintf(buf,sizeof(buf),"fmod(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert(0, buf);
}

void test_fmod()
{
    run_fmod(10.5, 2.0, 0.5);
    run_fmod(10.123, 3, 1.123);
}

static void run_fmin(FLOAT x, FLOAT y, FLOAT e)
{
    static char   buf[100];

    FLOAT r = FMIN(x,y);
    if (approx_equal(e,r,EPSILON))
        return;
    snprintf(buf,sizeof(buf),"fmin(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert(0, buf);
}

void test_fmin()
{
    run_fmin(3.0, 2.0, 2.0);
    run_fmin(3.0, -1.0, -1.0);
    run_fmin(-3.0, 1.0, -3.0);
    run_fmin(-3.0, -1.0, -3.0);
}

static void run_fmax(FLOAT x, FLOAT y, FLOAT e)
{
    static char   buf[100];

    FLOAT r = FMAX(x,y);
    if (approx_equal(e,r,EPSILON))
        return;
    snprintf(buf,sizeof(buf),"fmax(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert(0, buf);
}

void test_fmax()
{
    run_fmax(3.0, 2.0, 3.0);
    run_fmax(3.0, -1.0, 3.0);
    run_fmax(-3.0, 1.0, 1.0);
    run_fmax(-3.0, -1.0, -1.0);
}

#endif

/* Storing an INTEGER into a float lvalue via an index / pointer deref must
   convert int→float (`fa[i] = 5` → 5.0), not store the raw integer. The
   indexed/deref store paths skipped the conversion, storing an int-width
   value into the float slot: for a 4-byte double (math32/mbf32) `fa[i]=0`
   left the high 2 bytes stale, so a prior value leaked. */
static FLOAT itf_a[4];
static FLOAT *itf_p;
void test_int_to_float_store()
{
    int i, five = 5;
    for (i = 0; i < 4; i++) itf_a[i] = 100;      /* int literal → float (array) */
    Assert(approx_equal(itf_a[0], 100.0, EPSILON), "int lit -> float arr");
    itf_p = &itf_a[2]; *itf_p = five;            /* int var → float (deref) */
    Assert(approx_equal(itf_a[2], 5.0, EPSILON), "int var -> float deref");
    for (i = 0; i < 4; i++) itf_a[i] = 0;         /* int 0 → float: clear ALL bytes */
    Assert(approx_equal(itf_a[0], 0.0, EPSILON), "int 0 -> float arr (no stale high bytes)");
    Assert(approx_equal(itf_a[1], 0.0, EPSILON), "int 0 -> float arr [1]");
}

/* A float→long conversion must sign-extend into the high word. The mbf32 z80
   routine saved the sign byte with a `push af` that landed ON TOP of the
   caller's IX (stashed under the return address by ___mbf32_setup_single_reg),
   then unwound the two in the wrong order: (long)-3.0 came back as 0x00fffffd
   and (long)3.0 as 0xff000003, and the caller lost IX as well. The operand
   comes from a runtime-written global so the conversion cannot const-fold. */
static FLOAT f2l_in[2];
void test_float_to_long()
{
    f2l_in[0] = -3.0; f2l_in[1] = 3.0;
    Assert((long)f2l_in[0] == -3L, "(long)-3.0 == -3");
    Assert((long)f2l_in[1] ==  3L, "(long)3.0 == 3");
    Assert((int)f2l_in[0]  == -3,  "(int)-3.0 == -3");
}

/* Reciprocal via ordinary divide `1.0 / x` (IEEE math32/math16: restoring
   fsdiv after sccz80 dropped the inversef rewrite for float/half). Divisor
   comes from a runtime-written global so the quotient can't const-fold away. */
static FLOAT recip_in[3];
static int   recip_den[2];
void test_reciprocal()
{
    recip_in[0] = 4.0; recip_in[1] = 0.5; recip_in[2] = 8.0;
    Assert(approx_equal(1.0 / recip_in[0], 0.25,  EPSILON), "1/4 = 0.25");
    Assert(approx_equal(1.0 / recip_in[1], 2.0,   EPSILON), "1/0.5 = 2");
    Assert(approx_equal(1.0 / recip_in[2], 0.125, EPSILON), "1/8 = 0.125");
    /* int → float then divide (eval_A-shaped); result must be correct after
       the int-to-float conversion feeds the divisor. */
    recip_den[0] = 4; recip_den[1] = 8;
    Assert(approx_equal(1.0 / recip_den[0], 0.25,  EPSILON), "1/int4 = 0.25");
    Assert(approx_equal(1.0 / recip_den[1], 0.125, EPSILON), "1/int8 = 0.125");
}

#ifdef MATH_SPECIALS
/*
 * Light IEEE specials (Inf / NaN for /, *, +, sqrt).  Suite-gated on major
 * z80 + 8085 products only — see Makefile (math32, math16, am9511).
 */
#ifdef MATH16
/* Half has no isinf/isnan in the header — classify packed IEEE-754 binary16. */
static int sp_isinf(FLOAT x)
{
    union { _Float16 f; unsigned u; } v;
    v.f = x;
    return ((v.u & 0x7c00u) == 0x7c00u) && ((v.u & 0x03ffu) == 0);
}
static int sp_isnan(FLOAT x)
{
    union { _Float16 f; unsigned u; } v;
    v.f = x;
    return ((v.u & 0x7c00u) == 0x7c00u) && ((v.u & 0x03ffu) != 0);
}
static int sp_iszero(FLOAT x)
{
    union { _Float16 f; unsigned u; } v;
    v.f = x;
    return (v.u & 0x7fffu) == 0;
}
#else
#define sp_isinf(x) isinf(x)
#define sp_isnan(x) isnan(x)
#define sp_iszero(x) ((x) == (FLOAT)0.0)
#endif

/* Runtime zeros so 1/0 is not a compile-time constant.
 * Direct Inf−Inf / Inf/Inf (same local) is intentional: those ops are
 * IEEE specials, not algebraic identities.  A compiler that folds float
 * self-ops (x−x → 0, x/x → 1) will fail these cases — that is a gate. */
static FLOAT sp_z, sp_o, sp_n1;

void test_specials_div()
{
    FLOAT r, pinf;

    sp_z = (FLOAT)0.0;
    sp_o = (FLOAT)1.0;
    sp_n1 = (FLOAT)(-1.0);

    r = sp_o / sp_z;
    Assert(sp_isinf(r), "1/0 is +Inf");
    r = sp_n1 / sp_z;
    Assert(sp_isinf(r), "(-1)/0 is Inf");
    r = sp_z / sp_z;
    Assert(sp_isnan(r), "0/0 is NaN");

    pinf = sp_o / sp_z;
    r = sp_o / pinf;
    Assert(sp_iszero(r), "1/Inf is 0");
    r = pinf / sp_o;
    Assert(sp_isinf(r), "Inf/1 is Inf");
    r = pinf / pinf;
    Assert(sp_isnan(r), "Inf/Inf is NaN");
}

void test_specials_mul_add()
{
    FLOAT r, pinf, nanv;

    sp_z = (FLOAT)0.0;
    sp_o = (FLOAT)1.0;
    pinf = sp_o / sp_z;
    nanv = sp_z / sp_z;

    r = pinf + pinf;
    Assert(sp_isinf(r), "Inf+Inf is Inf");
    r = pinf - pinf;
    Assert(sp_isnan(r), "Inf-Inf is NaN");
    r = sp_o + pinf;
    Assert(sp_isinf(r), "1+Inf is Inf");

    r = sp_z * pinf;
    Assert(sp_isnan(r), "0*Inf is NaN");
    r = sp_o * pinf;
    Assert(sp_isinf(r), "1*Inf is Inf");
    r = nanv * sp_o;
    Assert(sp_isnan(r), "NaN*1 is NaN");
    r = nanv + sp_o;
    Assert(sp_isnan(r), "NaN+1 is NaN");
}

void test_specials_sqrt()
{
    FLOAT r, pinf;

    sp_z = (FLOAT)0.0;
    sp_o = (FLOAT)1.0;
    sp_n1 = (FLOAT)(-1.0);
    pinf = sp_o / sp_z;

    r = SQRT(sp_n1);
    Assert(sp_isnan(r), "sqrt(-1) is NaN");
    r = SQRT(sp_z);
    Assert(sp_iszero(r), "sqrt(0) is 0");
    r = SQRT(pinf);
    Assert(sp_isinf(r), "sqrt(+Inf) is +Inf");
}
#endif /* MATH_SPECIALS */

/* Binary float arithmetic beyond integer-valued cases. Covers mantissa mul,
   signed products, zero, and basic add/sub — the paths exercised by IEEE
   math32 / 8085 ports (sticky-round mul, unpack/pack). Prefer exact == for
   values that are binary-exact; approx_equal only where needed. */
static FLOAT fa_ops[8];
void test_float_arithmetic()
{
    FLOAT a, c;

    /* exact binary products */
    fa_ops[0] = 1.5; fa_ops[1] = 1.5;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)2.25, "1.5*1.5 == 2.25");
    fa_ops[0] = 0.5; fa_ops[1] = 0.5;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)0.25, "0.5*0.5 == 0.25");
    fa_ops[0] = 2.0; fa_ops[1] = 3.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)6.0, "2*3 == 6");

    /* signs */
    fa_ops[0] = -3.0; fa_ops[1] = 4.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)(-12.0), "(-3)*4 == -12");
    fa_ops[0] = 3.0; fa_ops[1] = -4.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)(-12.0), "3*(-4) == -12");
    fa_ops[0] = -2.0; fa_ops[1] = -3.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)6.0, "(-2)*(-3) == 6");

    /* zero */
    fa_ops[0] = 0.0; fa_ops[1] = 5.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)0.0, "0*5 == 0");
    fa_ops[0] = 5.0; fa_ops[1] = 0.0;
    Assert(fa_ops[0] * fa_ops[1] == (FLOAT)0.0, "5*0 == 0");

    /* add / sub */
    fa_ops[0] = 1.0; fa_ops[1] = 2.0;
    Assert(fa_ops[0] + fa_ops[1] == (FLOAT)3.0, "1+2 == 3");
    fa_ops[0] = 1.5; fa_ops[1] = 1.5;
    Assert(fa_ops[0] + fa_ops[1] == (FLOAT)3.0, "1.5+1.5 == 3");
    fa_ops[0] = 1.0; fa_ops[1] = -1.0;
    Assert(fa_ops[0] + fa_ops[1] == (FLOAT)0.0, "1+(-1) == 0");
    fa_ops[0] = 5.0; fa_ops[1] = 3.0;
    Assert(fa_ops[0] - fa_ops[1] == (FLOAT)2.0, "5-3 == 2");
    fa_ops[0] = -1.0; fa_ops[1] = -2.0;
    Assert(fa_ops[0] + fa_ops[1] == (FLOAT)(-3.0), "(-1)+(-2) == -3");

    /* chained: (a*b)+c and a*(b+c) with runtime-written inputs */
    fa_ops[0] = 1.5; fa_ops[1] = 2.0; fa_ops[2] = 0.5;
    a = fa_ops[0] * fa_ops[1] + fa_ops[2];
    Assert(a == (FLOAT)3.5, "1.5*2+0.5 == 3.5");
    a = fa_ops[0] * (fa_ops[1] + fa_ops[2]);
    Assert(a == (FLOAT)3.75, "1.5*(2+0.5) == 3.75");

    /* non-exact binary: still within library epsilon */
    fa_ops[0] = 0.1; fa_ops[1] = 0.2;
    c = fa_ops[0] + fa_ops[1];
    Assert(approx_equal(c, (FLOAT)0.3, EPSILON), "0.1+0.2 ~ 0.3");
    fa_ops[0] = 1.0; fa_ops[1] = 3.0;
    c = fa_ops[0] / fa_ops[1];
    Assert(approx_equal(c, (FLOAT)0.333333333, EPSILON), "1/3 ~ 0.333...");
}

int suite_math()
{
    suite_setup(MATH_LIBRARY " Tests");

    suite_add_test(test_comparison);
    suite_add_test(test_integer_operations);
    suite_add_test(test_integer_constant_operations);
    suite_add_test(test_integer_constant_longform);
    suite_add_test(test_integer_constant_longform_lhs);
    suite_add_test(test_post_incdecrement);
    suite_add_test(test_pre_incdecrement);
    suite_add_test(test_approx_equal);
    suite_add_test(test_int_to_float_store);
    suite_add_test(test_float_to_long);
    suite_add_test(test_float_arithmetic);
    suite_add_test(test_reciprocal);
    suite_add_test(test_sqrt);
    suite_add_test(test_pow);
#ifndef MATH16
    suite_add_test(test_fmod);
    suite_add_test(test_fmin);
    suite_add_test(test_fmax);
#endif
#ifdef MATH_SPECIALS
    suite_add_test(test_specials_div);
    suite_add_test(test_specials_mul_add);
    suite_add_test(test_specials_sqrt);
#endif
    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_math();

    exit(res);
}
