#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_compare0_char()
{
    char a = 0;
    char b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

void test_compare0_uchar()
{
    unsigned char a = 0;
    unsigned char b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

void test_compare0_int()
{
    int a = 0;
    int b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

void test_compare0_uint()
{
    unsigned int a = 0;
    unsigned int b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

void test_compare0_long()
{
    long a = 0;
    long b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

void test_compare0_ulong()
{
    unsigned long a = 0;
    unsigned long b = 1;

    if ( a == 0 ) { } else { Assert(1, "a == 0"); }
    if ( b == 0 ) { Assert(1, "b -= 0"); } 
    Assert( a == 0, "(a == 0)");
    Assert( (b == 0) == 0, "(b == 0) == 0");
 
    if ( a != 0 ) { Assert(1, "b != 0"); }
    if ( b != 0 ) { } else { Assert(1, "b != 0"); } 

    if ( a < 0 ) { Assert(1, "a < 0"); }
    if ( b < 0 ) { Assert(1, "b < 0"); } 
    if ( a <= 0 ) {} else { Assert(1, "a <= 0"); }
    if ( b <= 0 ) { Assert(1, "b <= 0"); } 

    if ( a > 0 ) { Assert(1, "a > 0"); }
    if ( b > 0 ) {} else { Assert(1, "b > 0"); } 
    if ( a >= 0 ) {} else { Assert(1, "a >= 0"); }
    if ( b >= 0 ) { Assert(1, "b >= 0"); } 
}

int suite_compare0()
{
    suite_setup("Compare0 Tests");
    suite_add_test(test_compare0_char);
    suite_add_test(test_compare0_uchar);
    suite_add_test(test_compare0_int);
    suite_add_test(test_compare0_uint);
    suite_add_test(test_compare0_long);
    suite_add_test(test_compare0_ulong);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_compare0();

    exit(res);
}
