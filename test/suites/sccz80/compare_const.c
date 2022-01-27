#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_compare1_char()
{
    char a = 0;
    char b = 1;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 
}

void test_compare1_uchar()
{
    unsigned char a = 0;
    unsigned char b = 1;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 
}

void test_compare1_int()
{
    int a = 0;
    int b = 1;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 
}

void test_compare1_uint()
{
    unsigned int a = 0;
    unsigned int b = 1;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 
}

void test_compare1_long()
{
    long a = 0;
    long b = 1;
    long c = -1000;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 

    if (c < -1000 ) { Assert(0,"c < -1000"); }
    if (c < -500 )  {} else { Assert(0,"c < -500"); }
    if (c < 1000 )  {} else { Assert(0,"c < 1000"); }
}

void test_compare1_ulong()
{
    unsigned long a = 0;
    unsigned long b = 1;

    if ( a == 1 ) { Assert(0, "a == 1"); }
    if ( b == 1 ) { } else { Assert(0, "b == 1"); } 
    Assert( b == 1, "(b == 1)");
    Assert( (a == 1) == 0, "(a == 1) == 0");
 
    if ( a != 1 ) { } else { Assert(0, "b != 1"); }
    if ( b != 1 ) { Assert(0, "b != 1"); } 

    if ( a < 1 ) {} else { Assert(0, "a < 1"); }
    if ( b < 1 ) { Assert(0, "b < 1"); } 
    if ( a <= 1 ) {} else { Assert(0, "a <= 1"); }
    if ( b <= 1 ) {} else { Assert(0, "b <= 1"); } 

    if ( a > 1 ) { Assert(0, "a > 1"); }
    if ( b > 1 ) { Assert(0, "b > 1"); } 
    if ( a >= 1 ) { Assert(0, "a >= 1"); }
    if ( b >= 1 ) {} else{ Assert(0, "b >= 1"); } 
}

int suite_compare1()
{
    suite_setup("Compare1 Tests");
    suite_add_test(test_compare1_char);
    suite_add_test(test_compare1_uchar);
    suite_add_test(test_compare1_int);
    suite_add_test(test_compare1_uint);
    suite_add_test(test_compare1_long);
    suite_add_test(test_compare1_ulong);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_compare1();

    exit(res);
}
