

#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#include <math.h>
#include <math/math_fix16.h>

#ifdef FIX16
    #define FABS(x) absk(x)
    #define SQRT(x) sqrtk(x);
    #define POW(x,y) powk(x,y)
    #define MUL(x,y) mulk(x,y)
    #define DIV(x,y) divk(x,y)
    typedef Accum FIX;
#endif

#ifdef FIX16
   #define EPSILON (0.1)
   #define TINY_POSITIVE 0x0001
#endif


void test_comparison()
{
     FIX a = FIX16_FROM_INT(10);
     FIX b = FIX16_FROM_INT(-2);

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
     FIX a = FIX16_TWO ;

     a += FIX16_TWO;
     Assert ( FIX16_TO_INT(a) == 4, "addition: a == 4");
     a = MUL(a, FIX16_TWO);
     Assert ( FIX16_TO_INT(a) == 8, "multiplication: a == 8");
     a = DIV(a,FIX16_TWO);
     Assert ( FIX16_TO_INT(a) == 4, "divide: a == 4");
     a -= FIX16_TWO;
     Assert ( FIX16_TO_INT(a) == 2, "subtract: a == 2");
}


static int approx_equal(FIX a, FIX b, FIX epsilon)
{
    FIX absa = FABS( a );
    FIX absb = FABS( b );
    FIX diff = FABS( a-b );

    if (a == b) {
        /* shortcut, handles infinities */
        return 1;
    } else {
        if ( a == 0 || b == 0 || ((absa + absb) < TINY_POSITIVE )) {
            /* a or b is zero or both are extremely close to it */
            /* relative error is less meaningful here           */
            return diff < (mulk(epsilon,TINY_POSITIVE));
        } else {
            /* use relative error */
            return divk(diff,(absa + absb)) < epsilon;
        }
    }
}



void test_approx_equal()
{
    Assert( approx_equal(FIX16_ONE,FIX16_TWO,EPSILON) == 0, " 1 != 2");
    Assert( approx_equal(FIX16_ONE,FIX16_ONE,EPSILON) == 1, " 1 == 1");
    //                   0.00000001
   // Assert( approx_equal(1.23456789,1.23456789,EPSILON) == 1, " 1.23456789 == 1.23456789");
#ifdef FIX16
    //                   0.005
   // Assert( approx_equal(1.24,1.22,EPSILON) == 0, " 1.24 != 1.22");
#endif
}

static void run_sqrt(FIX x, FIX e)
{
    static char   buf[100];

    FIX r = SQRT(x);
    snprintf(buf,sizeof(buf),"Sqrt(%f) should be %.14f but was %.14f",(float)x,(float)e,(float)r);
    Assert( approx_equal(e,r,EPSILON), buf);
}

void test_sqrt()
{
    run_sqrt(FIX16_FROM_FLOAT(4.0), FIX16_FROM_FLOAT(2.0));
    run_sqrt(FIX16_FROM_FLOAT(9.0), FIX16_FROM_FLOAT(3.0));
    run_sqrt(FIX16_FROM_FLOAT(1.0), FIX16_FROM_FLOAT(1.0));
    run_sqrt(FIX16_FROM_FLOAT(0.5), FIX16_FROM_FLOAT(0.70710678));
}

static void run_pow(FIX x, FIX y, FIX e)
{
    static char   buf[100];

    FIX r = POW(x,y);
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",FIX16_TO_FLOAT(x),FIX16_TO_FLOAT(y),FIX16_TO_FLOAT(e),FIX16_TO_FLOAT(r));
    Assert( approx_equal(e,r,EPSILON), buf);
}

void test_pow()
{
    run_pow(FIX16_FROM_FLOAT(2.0), FIX16_FROM_FLOAT(2.0), FIX16_FROM_FLOAT(4.0));
    run_pow(FIX16_FROM_FLOAT(0.5), FIX16_FROM_FLOAT(2.0), FIX16_FROM_FLOAT(0.25));
    run_pow(FIX16_FROM_FLOAT(2.0), FIX16_FROM_FLOAT(3.0), FIX16_FROM_FLOAT(8.0));
    run_pow(FIX16_FROM_FLOAT(2.0), FIX16_FROM_FLOAT(0.5), FIX16_FROM_FLOAT(1.42));
}

int suite_math()
{
    suite_setup(MATH_LIBRARY " Tests");

    suite_add_test(test_comparison);
    suite_add_test(test_integer_constant_operations);
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
