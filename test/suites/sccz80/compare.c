#include "test.h"
#include <stdio.h>
#include <stdlib.h>


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

int suite_compare()
{
    suite_setup("Compare Tests");
    suite_add_test(test_uint_compare);
    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_compare();

    exit(res);
}
