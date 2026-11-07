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

/* unsigned char promotes to int. 255 + 1 is 256, not a wrapped byte. */
void test_char_sum(void)
{
    volatile unsigned char vuc;
    volatile signed char vsc;
    unsigned char nv;
    volatile unsigned vu;

    vuc = 255;
    assertEqual((int)(vuc + 1 == 256), 1);
    assertEqual((int)(vuc + 1 >= 100), 1);
    assertEqual((int)(vuc + 2 > 200), 1);
    assertEqual((int)(vuc + 1 != 256), 0);
    assertEqual((int)(1 + vuc == 256), 1);
    assertEqual((int)(vuc + 1), 256);
    nv = 255;
    assertEqual((int)(nv + 1 == 256), 1);
    vsc = 127;
    assertEqual((int)(vsc + 1 < 100), 0);
    assertEqual((int)(vsc + 1 > -5), 1);
    assertEqual((int)(vuc == 256), 0);
    vu = 255;
    assertEqual((int)(1 + vu == 256), 1);
    vuc = 0;
    assertEqual((int)(vuc - 1), -1);
}

int suite_range(void)
{
    suite_setup("Signed minimum assignment");
    suite_add_test(test_mins);
    suite_add_test(test_char_sum);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_range();
    exit(res);
}
