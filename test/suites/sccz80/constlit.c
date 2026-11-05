#include "test.h"
#include <stdio.h>
#include <stdlib.h>

void test_float(void)
{
    assertEqual((long)1E5, 100000L);
    assertEqual((long)1e5, 100000L);
    assertEqual((long)1E+2, 100);
    assertEqual((long)1.25E2, 125);
    assertEqual((long)1.2E1, 12);
    assertEqual((long)1.5, 1);
}

void test_suffix(void)
{
    unsigned long a = 1LU;
    unsigned long b = 1UL;

    assertEqual(a, b);
    assertEqual(1L, 1);
    assertEqual(010LU, 8UL);
    /* Unsigned wrap. A signed 1L - 2 would not compare above 1. */
    assertEqual((int)((1LU - 2) > 1UL), 1);
    assertEqual((int)((1LLU - 2) > 1ULL), 1);
}

void test_octal(void)
{
    assertEqual(010, 8);
    assertEqual(077, 63);
    assertEqual(0, 0);
    assertEqual(00, 0);
    /* 8 and 9 are not octal digits. The value is the decimal reading. */
    assertEqual(089, 89);
    assertEqual(08, 8);
    assertEqual(0x89, 0x89);
    assertEqual(89, 89);
}

#ifndef __80CC
void test_range(void)
{
    /* 2^63 does not fit in signed long long. The bit pattern is kept. */
    assertEqual((long long)9223372036854775808LL, (long long)0x8000000000000000LL);
}
#endif

int suite_constlit(void)
{
    suite_setup("Literal constants");
    suite_add_test(test_float);
    suite_add_test(test_suffix);
    suite_add_test(test_octal);
#ifndef __80CC
    suite_add_test(test_range);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_constlit();
    exit(res);
}
