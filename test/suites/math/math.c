

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
#elif MATHDAI32
   #define EPSILON (0.000001)
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

     Assert( a > b, "a > b");
     Assert( a >= b, "a >= b");
     Assert( a != b, "a != b");
     Assert( b < a, "b < a");
     Assert( b <= a, "b <= a");
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
    snprintf(buf,sizeof(buf),"Sqrt(%f) should be %.14f but was %.14f",(float)x,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
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
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
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
    snprintf(buf,sizeof(buf),"fmod(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
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
    snprintf(buf,sizeof(buf),"fmin(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
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
    snprintf(buf,sizeof(buf),"fmax(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
}

void test_fmax()
{
    run_fmax(3.0, 2.0, 3.0);
    run_fmax(3.0, -1.0, 3.0);
    run_fmax(-3.0, 1.0, 1.0);
    run_fmax(-3.0, -1.0, -1.0);
}

#endif

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
    suite_add_test(test_sqrt);
    suite_add_test(test_pow);
#ifndef MATH16
    suite_add_test(test_fmod);
    suite_add_test(test_fmin);
    suite_add_test(test_fmax);
#endif
    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_math();

    exit(res);
}
