#include "test.h"
#include <stdio.h>
#include <stdlib.h>

signed char cmin = -128;
int imin = -32768;
volatile signed char yc = -128;

void test_mins(void)
{
    signed char c;
    volatile signed char v;
    int i;

    c = -128;
    v = -128;
    i = -32768;
    assertEqual(cmin, -128);
    assertEqual(imin, -32768);
    assertEqual(yc, -128);
    assertEqual(c, -128);
    assertEqual((int)v, -128);
    assertEqual(i, -32768);
    assertEqual(cmin + 1, -127);
    assertEqual(imin + 1, -32767);
}

int suite_range(void)
{
    suite_setup("Signed minimum assignment");
    suite_add_test(test_mins);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_range();
    exit(res);
}
