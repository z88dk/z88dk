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
    unsigned int  b = 20;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
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
    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
}

void test_ulong_compare() 
{
    unsigned long  a = 10;
    unsigned long  b = 20;

    Assert( a < b, "a < b");
    if ( a < b ) {} else { Assert(0, "a < b"); }
    Assert( a <= b, "a <= b");
    if ( a <= b ) {} else { Assert(0, "a <= b"); }
    Assert( a != b, "a != b");
    if ( a != b ) {} else { Assert(0, "a != b"); }
    Assert( a == a, "a == a");
    if ( a == a ) {} else { Assert(0, "a == b"); }
    Assert( b >  a, "b > a");
    if ( b > a ) {} else { Assert(0, "b > a"); }
    Assert( b >= a, "b >= a");
    if ( b >= a ) {} else { Assert(0, "b >= a"); }
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
    suite_add_test(test_ulong_compare);
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
