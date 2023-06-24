#include "test.h"
#include <stdio.h>
#include <stdlib.h>


#ifndef __8080__
  #ifndef __GBZ80__
void test_longlong_mult() 
{
     long long val = 3;

     Assert( val * 655360 == 655360 * 3, "3 * 655360");
     Assert( val * 256 == 768, "3 * 256");
     Assert( val * 8  == 24, "3 * 8");
     Assert( val * 4  == 12, "3 * 4");
     Assert( val * 2  == 6, "3 * 2");
     Assert( val * 3  == 9, "3 * 3");
     Assert( val * 5  == 15, "3 * 5");
     Assert( val * 6  == 18, "3 * 6");
}
  #endif
#endif

void test_quickmult_long()
{
     long val = 3;

     Assert( val * 256 == 768, "3 * 256");
     Assert( val * 64 == 192, "3 * 64");
     Assert( val * 2  == 6, "3 * 2");
     Assert( val * 3  == 9, "3 * 3");
     Assert( val * 4  == 12, "3 * 4");
     Assert( val * 5  == 15, "3 * 5");
     Assert( val * 6  == 18, "3 * 6");
     Assert( val * 7  == 21, "3 * 7");
     Assert( val * 8  == 24, "3 * 8");
     Assert( val * 9  == 27, "3 * 9");
     Assert( val * 40 == 120, "3 * 40");
}

void test_mult_long()
{
     long val1 = 3;
     long val2 = 5;

     Assert(  val1 *  val2  ==  15, " 3 *  5");
     Assert(  val1 * -val2  == -15, " 3 * -5");
     Assert( -val1 *  val2  == -15, "-3 *  5");
     Assert( -val1 * -val2  ==  15, "-3 * -5");
     Assert(  val2 *  val1  ==  15, " 5 *  3");
     Assert(  val2 * -val1  == -15, " 5 * -3");
     Assert( -val2 *  val1  == -15, "-5 *  3");
     Assert( -val2 * -val1  ==  15, "-5 * -3");
}

void test_mult_int()
{
     int val1 = 3;
     int val2 = 5;

     Assert(  val1 *  val2  ==  15, " 3 *  5");
     Assert(  val1 * -val2  == -15, " 3 * -5");
     Assert( -val1 *  val2  == -15, "-3 *  5");
     Assert( -val1 * -val2  ==  15, "-3 * -5");
     Assert(  val2 *  val1  ==  15, " 5 *  3");
     Assert(  val2 * -val1  == -15, " 5 * -3");
     Assert( -val2 *  val1  == -15, "-5 *  3");
     Assert( -val2 * -val1  ==  15, "-5 * -3");
}

int suite_mult()
{
    suite_setup("Multiplication Tests");

    suite_add_test(test_quickmult_long);

#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_longlong_mult);
  #endif
#endif

    suite_add_test(test_mult_long);
    suite_add_test(test_mult_int);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
