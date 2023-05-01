

#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#include <math.h>
#include <math/math_fix88.h>

#ifdef FIX88
    #define FABS(x) fabsfix88(x)
    #define SQRT(x) sqrtfix88(x);
    #define POW(x,y) powfix88(x,y)
    #define MUL(x,y) mulfix88(x,y)
    #define DIV(x,y) divfix88(x,y)
    typedef fix88_t FIX;
#endif

#ifdef FIX88
   #define EPSILON (0.1)
   #define TINY_POSITIVE 0x0001
#endif


void test_comparison()
{
     FIX a = FIX88_FROM_INT(10);
     FIX b = FIX88_FROM_INT(-2);

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
     FIX a = FIX88_TWO ;

     a += FIX88_TWO;
     Assert ( FIX88_TO_INT(a) == 4, "addition: a == 4");
     a = MUL(a, FIX88_TWO);
     Assert ( FIX88_TO_INT(a) == 8, "multiplication: a == 8");
     a = DIV(a,FIX88_TWO);
     Assert ( FIX88_TO_INT(a) == 4, "divide: a == 4");
     a -= FIX88_TWO;
     Assert ( FIX88_TO_INT(a) == 2, "subtract: a == 2");
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
            return diff < (mulfix88(epsilon,TINY_POSITIVE));
        } else {
            /* use relative error */
            return divfix88(diff,(absa + absb)) < epsilon;
        }
    }
}



void test_approx_equal()
{
    Assert( approx_equal(FIX88_ONE,FIX88_TWO,EPSILON) == 0, " 1 != 2");
    Assert( approx_equal(FIX88_ONE,FIX88_ONE,EPSILON) == 1, " 1 == 1");
    //                   0.00000001
   // Assert( approx_equal(1.23456789,1.23456789,EPSILON) == 1, " 1.23456789 == 1.23456789");
#ifdef FIX88
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
    run_sqrt(FIX88_FROM_FLOAT(4.0), FIX88_FROM_FLOAT(2.0));
    run_sqrt(FIX88_FROM_FLOAT(9.0), FIX88_FROM_FLOAT(3.0));
    run_sqrt(FIX88_FROM_FLOAT(1.0), FIX88_FROM_FLOAT(1.0));
    run_sqrt(FIX88_FROM_FLOAT(0.5), FIX88_FROM_FLOAT(0.70710678));
}

static void run_pow(FIX x, FIX y, FIX e)
{
    static char   buf[100];

    FIX r = POW(x,y);
    snprintf(buf,sizeof(buf),"pow(%f,%f) should be %.14f but was %.14f",FIX88_TO_FLOAT(x),FIX88_TO_FLOAT(y),FIX88_TO_FLOAT(e),FIX88_TO_FLOAT(r));
    Assert( approx_equal(e,r,EPSILON), buf);
}

void test_pow()
{
    run_pow(FIX88_FROM_FLOAT(2.0), FIX88_FROM_FLOAT(2.0), FIX88_FROM_FLOAT(4.0));
    run_pow(FIX88_FROM_FLOAT(0.5), FIX88_FROM_FLOAT(2.0), FIX88_FROM_FLOAT(0.25));
    run_pow(FIX88_FROM_FLOAT(2.0), FIX88_FROM_FLOAT(3.0), FIX88_FROM_FLOAT(8.0));
    run_pow(FIX88_FROM_FLOAT(2.0), FIX88_FROM_FLOAT(0.5), FIX88_FROM_FLOAT(1.42));
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
