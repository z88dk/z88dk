

#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#ifdef MATH16
#include <math/math_math16.h>
typedef _Float16 FLOAT;
#else
#include <math.h>
typedef double FLOAT;
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
#ifdef MATH16
     a = 4;
#elif MATH32
     a = 4;
#endif
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
#ifdef MATH16
     a = 4;
#elif MATH32
     a = 4;
#endif
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

static int approx_equal(FLOAT a, FLOAT b)
{
#ifdef MATH16
   if ( fabsf16(b-a) < 0.01) {
#elif MATH32
   if ( fabs(b-a) < 0.0001) {
#elif MATHDAI32
   if ( fabs(b-a) < 0.01) {
#else
   if ( fabs(b-a) < 0.00000001 ) {
#endif
       return 1;
   }
   return 0;
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
    Assert( approx_equal(1.0,2.0) == 0, " 1 != 2");
    Assert( approx_equal(1.0,1.0) == 1, " 1 == 1");
    //                   0.00000001
    Assert( approx_equal(1.23456789,1.23456789) == 1, " 1.23456789 == 1.23456789");
#ifdef MATH16
    //                   0.02
    Assert( approx_equal(1.24,1.22) == 0, " 1.24 != 1.22");
#elif MATH32
    //                   0.0001
    Assert( approx_equal(1.2345,1.2344) == 0, " 1.2345 != 1.2344");
#elif MATHDAI32
#else
    //                   0.00000001
    Assert( approx_equal(1.23456789,1.23456788) == 0, " 1.23456789 != 1.23456788");
#endif
}

static void run_sqrt(FLOAT x, FLOAT e)
{
    static char   buf[100];
#ifdef MATH16
    FLOAT r = sqrtf16(x);
#else
    FLOAT r = sqrt(x);
#endif
    snprintf(buf,sizeof(buf),"Sqrt(%f) should be %.14f but was %.14f",(float)x,(float)e,(float)r);
    Assert( approx_equal(e,r), buf);
}

void test_sqrt()
{
    run_sqrt(4.0, 2.0);
    run_sqrt(9.0, 3.0);
    run_sqrt(1.0, 1.0);
#ifdef MATH16
    run_sqrt(6400, 80.0);
#else
    run_sqrt(1000000, 1000.0);
#endif
    run_sqrt(0.5, 0.70710678);
}

static void run_pow(FLOAT x, FLOAT y, FLOAT e)
{
    static char   buf[100];
#ifdef MATH16
    FLOAT r = powf16(x,y);
#else
    FLOAT r = pow(x,y);
#endif
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",(float)x,(float)y,(float)e,(float)r);
    Assert( approx_equal(e,r), buf);
}

void test_pow()
{
    run_pow(2.0, 2.0, 4.0);
    run_pow(0.5, 2.0, 0.25);
    run_pow(4.0, 3.0, 64.0);
    run_pow(2, 0.5, 1.41421356);
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
    suite_add_test(test_sqrt);
    suite_add_test(test_pow);
    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_math();

    exit(res);
}
