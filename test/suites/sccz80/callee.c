


#include "test.h"
#include <stdio.h>

void myfunc()
{
}

int callee1(double x, double y) __z88dk_callee
{
    double a,b,c;

    myfunc();

    return -23;
}

long callee2(double x, double y) __z88dk_callee
{
    double a,b,c;

    myfunc();

    return -27L;
}

double callee3(double x, double y) __z88dk_callee
{
    double a,b,c;

    myfunc();

    return -27.0;
}


void test_callee()
{
    Assert( callee1(1.0,2.0) == -23, "Callee1 should give us -23");
    Assert( callee2(1.0,2.0) == -27L, "Callee2 should give us -27");
    Assert( callee3(1.0,2.0) == -27.0, "Callee2 should give us -27");
}


int suite_callee()
{
    suite_setup("Callee Tests");

    suite_add_test(test_callee);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_callee();

    exit(res);
}
