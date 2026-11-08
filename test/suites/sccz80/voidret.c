#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void quiet(void)
{
    return;
}

int value(void)
{
    return 4;
}

void test_return(void)
{
    quiet();
    assertEqual(value(), 4);
}

int suite_voidret(void)
{
    suite_setup("Return from a void function");
    suite_add_test(test_return);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_voidret();
    exit(res);
}
