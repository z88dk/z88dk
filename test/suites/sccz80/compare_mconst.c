#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_comparem1_char()
{
    char a = 0;
    char b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( b == -1, "(b == -1)");
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

void test_comparem1_uchar()
{
    unsigned char a = 0;
    unsigned char b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

void test_comparem1_int()
{
    int a = 0;
    int b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( b == -1, "(b == -1)");
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

void test_comparem1_uint()
{
    unsigned int a = 0;
    unsigned int b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

void test_comparem1_long()
{
    long a = 0;
    long b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( b == -1, "(b == -1)");
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

void test_comparem1_ulong()
{
    unsigned long a = 0;
    unsigned long b = -1;

    if ( a == -1 ) { Assert(-1, "a == -1"); }
    if ( b == -1 ) { } else { Assert(-1, "b == -1"); } 
    Assert( b == -1, "(b == -1)");
    Assert( (a == -1) == 0, "(a == -1) == 0");
 
    if ( a != -1 ) { } else { Assert(-1, "b != -1"); }
    if ( b != -1 ) { Assert(-1, "b != -1"); } 

    if ( a < -1 ) {} else { Assert(-1, "a < -1"); }
    if ( b < -1 ) { Assert(-1, "b < -1"); } 
    if ( a <= -1 ) {} else { Assert(-1, "a <= -1"); }
    if ( b <= -1 ) {} else { Assert(-1, "b <= -1"); } 

    if ( a > -1 ) { Assert(-1, "a > -1"); }
    if ( b > -1 ) { Assert(-1, "b > -1"); } 
    if ( a >= -1 ) { Assert(-1, "a >= -1"); }
    if ( b >= -1 ) {} else{ Assert(-1, "b >= -1"); } 
}

int suite_comparem1()
{
    suite_setup("Compare-1 Tests");
    suite_add_test(test_comparem1_char);
    suite_add_test(test_comparem1_uchar);
    suite_add_test(test_comparem1_int);
    suite_add_test(test_comparem1_uint);
    suite_add_test(test_comparem1_long);
    suite_add_test(test_comparem1_ulong);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_comparem1();

    exit(res);
}
