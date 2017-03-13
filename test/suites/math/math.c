


#include "test.h"
#include <stdio.h>
#include <math.h>

void test_comparison()
{
     double a = 10.0;
     double b = 2.0;

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
     double a = 2;

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
     double a = 2;
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
     double a = 2;

     a = 2 + a;
     Assert ( a == 4, "addition: a == 4");
     a = 2 * a;
     Assert ( a == 8, "multiply: a == 8");
     a = 32. / a;
     Assert ( a == 4, "divide: a == 4");
     a = 6 - a;
     Assert ( a == 2, "subtract: a == 2");
}

void test_integer_constant_longform()
{
     double a = 2;

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
     double a = 2;

     a++;
     Assert( a == 3, "++: a == 3");
     a--;
     Assert( a == 2, "--: a == 2");
}

static int approx_equal(double a, double b)
{
   if ( fabs(b-a) < 0.00000001 ) {
       return 1;
   }
   return 0;
}

void test_pre_incdecrement()
{
     double a = 2;

     ++a;
     Assert( a == 3, "++: a == 3");
     --a;
     Assert( a == 2, "--: a == 2");
}

static void run_sqrt(double x, double e)
{
    static char   buf[100];
    double r = sqrt(x);
    snprintf(buf,sizeof(buf),"Sqrt(%f) should be %.14f but was %.14f",x,e,r);
    Assert( approx_equal(e,r), buf);
}

void test_sqrt()
{
    run_sqrt(4.0, 2.0);
    run_sqrt(9.0, 3.0);
    run_sqrt(1.0, 1.0);
    run_sqrt(1000000, 1000.0);
    run_sqrt(0.5, 0.70710678);

}

static void run_pow(double x, double y, double e)
{
    static char   buf[100];
    double r = pow(x,y);
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",x,y,e,r);
    Assert( approx_equal(e,r), buf);
}

void test_pow()
{
    run_pow(2.0, 2.0, 4.0);
    run_pow(0.5, 2.0, 0.25);
    run_pow(2, 0.5, 1.41421356);
}

void test_approx_equal()
{
    Assert( approx_equal(1.0,2.0) == 0, " 1 != 2");
    Assert( approx_equal(1.0,1.0) == 1, " 1 == 1");
    //                   0.00000001
    Assert( approx_equal(1.23456789,1.23456789) == 1, " 1.23456789 == 1.23456789");
    Assert( approx_equal(1.23456789,1.23456788) == 0, " 1.23456789 != 1.23456788");
}

int suite_genmath()
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

    res += suite_genmath();

    exit(res);
}
