#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#ifndef __8080__
  #ifndef __GBZ80__
    #define ENABLE_LLTESTS 1
  #endif
#endif


void test_uint_boundaries() 
{
    unsigned int  a = 20000;

    Assert( a < 30000, "a < 30000");
    Assert( (a < 20000) == 0, "a < 20000");
    Assert( (a < 10000) == 0, "a < 10000");
}

void test_int_boundaries() 
{
    int  a = 20000;

    Assert( a < 30000, "a < 30000");
    Assert( (a < 20000) == 0, "a < 20000");
    Assert( (a < 10000) == 0, "a < 10000");
    Assert( (a < -10000) == 0, "a < -10000");

    a = -10000;
    Assert( a < 30000, "a < 30000");
    Assert( a < 20000, "a < 20000");
    Assert( a < 10000, "a < 10000");
    Assert( a < -5000, "a < -500");
    Assert( (a < -10000) == 0, "a < -10000");  

}


void test_uint_compare() 
{
    unsigned int  a = 10;
    unsigned int  b = 0xc012;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( (a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a > b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b ) { Assert(0, "a >= b"); }

    Assert( ( a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a > b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b ) { Assert(0, "a <= b"); }

    Assert( b >  a, "b > a");
    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}


void test_long_compare() 
{
    long  a = -10;
    long  b = 20;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( b >  a, "b > a");

    Assert( (a > b) == 0, "a > b");
    if ( a > b )  { Assert(0, "a > b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b ) { Assert(0, "a <= b"); }



    Assert( (a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a < b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b ) { Assert(0, "a <= b"); }


    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}

void test_long_compare_issue2311() 
{
    signed long  a;
    signed long  b;
  
    signed short i;


    i=0x1000; a = (signed long) i;
    i=0x9000; b = (signed long) i;

    signed long *_a = &a;
    signed long *_b = &b;


    Assert( (unsigned long)*_a < (unsigned long)*_b, "a < b");
    if ( (unsigned long)*_a < (unsigned long)*_b ) {} else { Assert(0, "a < b"); }
    Assert( (unsigned long)*_a <= (unsigned long)*_b, "a <= b");
    if ( (unsigned long)*_a <= (unsigned long)*_b ) {} else { Assert(0, "a <= b"); }
    Assert( (unsigned long)*_a != (unsigned long)*_b, "a != b");
    if ( (unsigned long)*_a != (unsigned long)*_b ) {} else { Assert(0, "a != b"); }
    Assert( (unsigned long)*_a == (unsigned long)*_a, "a == a");
    if ((unsigned long)*_a == (unsigned long)*_a ) {} else { Assert(0, "a == b"); }

    Assert( ((unsigned long)*_a > (unsigned long)*_a) == 0, "a > b");
    if ( (unsigned long)*_a > (unsigned long)*_b ) { Assert(0, "a > b"); }
    Assert( ((unsigned long)*_a >= (unsigned long)*_b) == 0, "b >= a");
    if ( (unsigned long)*_a >= (unsigned long)*_b ) { Assert(0, "b >= a"); }


    Assert( (unsigned long)*_b > (unsigned long)*_a, "b > a");
    if ( (unsigned long)*_b > (unsigned long)*_a ) {} else { Assert(0, "b > a"); }
    Assert( (unsigned long)*_b >= (unsigned long)*_a, "b >= a");
    if ( (unsigned long)*_b >= (unsigned long)*_a ) {} else { Assert(0, "b >= a"); }
}

void ulong_compare(unsigned long a, unsigned long b)
{
    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( b >  a, "b > a");

    Assert( (a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a > b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b )  { Assert(0, "a <= b"); }


    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}

void test_ulong_compare_0x1000_0xffff9000() 
{
    unsigned long  a = 0x1000;
    unsigned long  b = 0xffff9000;

    ulong_compare(a,b);
}

void test_ulong_compare_0x1000_0xf0009000() 
{
    unsigned long  a = 0x1000;
    unsigned long  b = 0xf0009000;

    ulong_compare(a,b);
}

void test_ulong_compare_0x1000_0xff009000() 
{
    unsigned long  a = 0x1000;
    unsigned long  b = 0xff009000;

    ulong_compare(a,b);
}

void test_ulong_compare_0x1000_0xf8009000() 
{
    unsigned long  a = 0x1000;
    unsigned long  b = 0xf8009000;

    ulong_compare(a,b);
}

void test_ulong_compare_0x1000_0xf0f09000() 
{
    unsigned long  a = 0x1000;
    unsigned long  b = 0xf0f09000;

    ulong_compare(a,b);
}

void test_ulong_compare_0x10_0x20() 
{
    unsigned long  a = 0x10;
    unsigned long  b = 0x20;

    ulong_compare(a,b);
}
 
 

#ifdef ENABLE_LLTESTS
void test_llong_compare() 
{
    long long a = -10;
    long long b = 20;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( b >  a, "b > a");
    Assert( (a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a < b"); }
    Assert( (a >= b) == 0, "a <= b");
    if ( a >= b ) { Assert(0, "a <= b"); }


    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}

void test_ullong_compare() 
{
    unsigned long long a = 10;
    unsigned long long b = 20;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( (a > b) == 0, "a > b");
    if ( a > b ) { Assert(0, "a > b"); }
    Assert( (a >= b) == 0, "a >= b");
    if ( a >= b )  { Assert(0, "a <= b"); }


    Assert( b >  a, "b > a");
    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}
#endif


int suite_compare()
{
    suite_setup("Compare Tests");
    suite_add_test(test_uint_compare);
    suite_add_test(test_uint_boundaries);
    suite_add_test(test_int_boundaries);
    suite_add_test(test_long_compare);
    suite_add_test(test_long_compare_issue2311);
    suite_add_test(test_ulong_compare_0x1000_0xffff9000);
    suite_add_test(test_ulong_compare_0x1000_0xf0009000);
    suite_add_test(test_ulong_compare_0x1000_0xff009000);
    suite_add_test(test_ulong_compare_0x1000_0xf8009000);
    suite_add_test(test_ulong_compare_0x1000_0xf0f09000);
    suite_add_test(test_ulong_compare_0x10_0x20);
#ifdef ENABLE_LLTESTS
    suite_add_test(test_llong_compare);
    suite_add_test(test_ullong_compare);
#endif
    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_compare();

    exit(res);
}
