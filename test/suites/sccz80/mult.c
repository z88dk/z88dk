#include "test.h"
#include <stdio.h>
#include <stdlib.h>


#ifndef __8080__
  #ifndef __GBZ80__
void test_mult_longlong() 
{
     long long val1 = 3;
     long long val2 = 5;

     Assert(  val1 * 655360 == 655360 * 3, "3 * 655360");
     Assert(  val1 * 256 == 768, "3 * 256");
     Assert(  val1 * 8  == 24, "3 * 8");
     Assert(  val1 * 4  == 12, "3 * 4");
     Assert(  val1 * 2  == 6, "3 * 2");
     Assert(  val1 * 3  == 9, "3 * 3");
     Assert(  val1 * 5  == 15, "3 * 5");
     Assert(  val1 * 6  == 18, "3 * 6");

     Assert(  val1 *  val2  ==  15, " 3 *  5");
     Assert(  val1 * -val2  == -15, " 3 * -5");
     Assert( -val1 *  val2  == -15, "-3 *  5");
     Assert( -val1 * -val2  ==  15, "-3 * -5");
     Assert(  val2 *  val1  ==  15, " 5 *  3");
     Assert(  val2 * -val1  == -15, " 5 * -3");
     Assert( -val2 *  val1  == -15, "-5 *  3");
     Assert( -val2 * -val1  ==  15, "-5 * -3");
}

void test_mult_unsigned_longlong() 
{
     unsigned long long val1 = 3;
     unsigned long long val2 = 5;
     unsigned long long val3 = 0x2AAAAAAB;
     unsigned long long val4 = 0x2AAAAAAAAAAAAAAB;

     Assert( val1 * 655360 == 655360 * 3, "3 * 655360");
     Assert( val1 * 256 == 768, "3 * 256");
     Assert( val1 * 8  == 24, "3 * 8");
     Assert( val1 * 4  == 12, "3 * 4");
     Assert( val1 * 2  == 6, "3 * 2");
     Assert( val1 * 3  == 9, "3 * 3");
     Assert( val1 * 5  == 15, "3 * 5");
     Assert( val1 * 6  == 18, "3 * 6");

     Assert( val1 * val2  ==  15, "3 * 5");
     Assert( val2 * val1  ==  15, "5 * 3");

     Assert( val1 * val3  ==  0x80000001, "3 * 0x2AAAAAAB");
     Assert( val3 * val1  ==  0x80000001, "0x2AAAAAAB * 3");
#ifdef TEST_LONGLONG
     Assert( val1 * val4  ==  0x8000000000000001, "3 * 0x2AAAAAAAAAAAAAAB");
     Assert( val4 * val1  ==  0x8000000000000001, "0x2AAAAAAAAAAAAAAB * 3");
#endif

     Assert( val1 * val3 * 3 ==  0x180000003, "3 * 0x2AAAAAAB * 3");
     Assert( val3 * val1 * 3 ==  0x180000003, "0x2AAAAAAB * 3 * 3");
}

  #endif
#endif

void test_quickmult_long()
{
     long val = 3;

     Assert(  val * 256 == 768, "3 * 256");
     Assert(  val * 64 == 192, "3 * 64");
     Assert(  val * 2  == 6, "3 * 2");
     Assert(  val * 3  == 9, "3 * 3");
     Assert(  val * 4  == 12, "3 * 4");
     Assert(  val * 5  == 15, "3 * 5");
     Assert(  val * 6  == 18, "3 * 6");
     Assert(  val * 7  == 21, "3 * 7");
     Assert(  val * 8  == 24, "3 * 8");
     Assert(  val * 9  == 27, "3 * 9");
     Assert(  val * 40 == 120, "3 * 40");

     Assert( -val * 256 == -768, "3 * 256");
     Assert( -val * 64 == -192, "3 * 64");
     Assert( -val * 2  == -6, "3 * 2");
     Assert( -val * 3  == -9, "3 * 3");
     Assert( -val * 4  == -12, "3 * 4");
     Assert( -val * 5  == -15, "3 * 5");
     Assert( -val * 6  == -18, "3 * 6");
     Assert( -val * 7  == -21, "3 * 7");
     Assert( -val * 8  == -24, "3 * 8");
     Assert( -val * 9  == -27, "3 * 9");
     Assert( -val * 40 == -120, "3 * 40");
}

void test_mult_long()
{
     long val1 = 3;
     long val2 = 5;
     long val3 = 10923;
     long val4 = 715827883;
     long val5 = 32769;

     Assert(  val1 *  val2  ==  15, " 3 *  5");
     Assert(  val1 * -val2  == -15, " 3 * -5");
     Assert( -val1 *  val2  == -15, "-3 *  5");
     Assert( -val1 * -val2  ==  15, "-3 * -5");
     Assert(  val2 *  val1  ==  15, " 5 *  3");
     Assert(  val2 * -val1  == -15, " 5 * -3");
     Assert( -val2 *  val1  == -15, "-5 *  3");
     Assert( -val2 * -val1  ==  15, "-5 * -3");

     Assert(  val1 *  val3  ==  32769, " 3 *  10923");
     Assert(  val1 * -val3  == -32769, " 3 * -10923");
     Assert( -val1 *  val3  == -32769, "-3 *  10923");
     Assert( -val1 * -val3  ==  32769, "-3 * -10923");
     Assert(  val3 *  val1  ==  32769, " 10923 *  3");
     Assert(  val3 * -val1  == -32769, " 10923 * -3");
     Assert( -val3 *  val1  == -32769, "-10923 *  3");
     Assert( -val3 * -val1  ==  32769, "-10923 * -3");

     Assert(  val1 *  val4  ==  2147483649, " 3 *  715827883");
     Assert(  val1 * -val4  == -2147483649, " 3 * -715827883");
     Assert( -val1 *  val4  == -2147483649, "-3 *  715827883");
     Assert( -val1 * -val4  ==  2147483649, "-3 * -715827883");
     Assert(  val4 *  val1  ==  2147483649, " 715827883 *  3");
     Assert(  val4 * -val1  == -2147483649, " 715827883 * -3");
     Assert( -val4 *  val1  == -2147483649, "-715827883 *  3");
     Assert( -val4 * -val1  ==  2147483649, "-715827883 * -3");

     Assert(  val5 *  val5  ==  1073807361, " 32769 *  32769");
     Assert(  val5 * -val5  == -1073807361, " 32769 * -32769");
     Assert( -val5 *  val5  == -1073807361, "-32769 *  32769");
     Assert( -val5 * -val5  ==  1073807361, "-32769 * -32769");
}

void test_mult_unsigned_long()
{
     unsigned long val1 = 3;
     unsigned long val2 = 5;
     unsigned long val3 = 0x2AAB;
     unsigned long val4 = 0x2AAAAAAB;
     unsigned long val5 = 0x8001;

     Assert( val1 * val2  ==  15, "3 * 5");
     Assert( val2 * val1  ==  15, "5 * 3");

     Assert( val1 * val3  ==  0x8001, "3 * 0x2AAB");
     Assert( val3 * val1  ==  0x8001, "0x2AAB * 3");

     Assert( val1 * val4  ==  0x80000001, "3 * 0x2AAAAAAB");
     Assert( val4 * val1  ==  0x80000001, "0x2AAAAAAB * 3");

     Assert( val5 * val5  ==  0x40010001, "0x8001 * 0x8001");
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

void test_mult_unsigned_int()
{
     unsigned int val1 = 3;
     unsigned int val2 = 5;

     unsigned long val3 = 0x2B;
     unsigned long val4 = 0x2AAB;

     Assert( val1 * val2  ==  15, "3 * 5");
     Assert( val2 * val1  ==  15, "5 * 3");

     Assert( val1 * val3  ==  0x81, "3 * 0x2B");
     Assert( val3 * val1  ==  0x81, "0x2B * 3");
     Assert( val1 * val4  ==  0x8001, "3 * 0x2AAB");
     Assert( val4 * val1  ==  0x8001, "0x2AAB * 3");

     Assert( val1 * val3 * 3 ==  0x183, "3 * 0x2B * 3");
     Assert( val3 * val1 * 3 ==  0x183, "0x2B * 3 * 3");
}

int suite_mult()
{
    suite_setup("Multiplication Tests");

    suite_add_test(test_quickmult_long);

    suite_add_test(test_mult_int);
    suite_add_test(test_mult_unsigned_int);
    suite_add_test(test_mult_long);
    suite_add_test(test_mult_unsigned_long);

#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_mult_longlong);
    suite_add_test(test_mult_unsigned_longlong);
  #endif
#endif

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
