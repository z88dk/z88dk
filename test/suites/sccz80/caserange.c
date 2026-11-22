#include "test.h"
#include <stdio.h>
#include <stdlib.h>

int on_int(int x)
{
    switch (x) {
    case -32768: return 1;
    case 32767: return 2;
    case 0: return 3;
    default: return 0;
    }
}

int on_uint(unsigned x)
{
    switch (x) {
    case 0: return 1;
    case 65535u: return 2;
    default: return 0;
    }
}

int on_uchar(unsigned char x)
{
    switch (x) {
    case 0: return 1;
    case 255: return 2;
    case 1: return 3;
    default: return 0;
    }
}

int on_schar(signed char x)
{
    switch (x) {
    case -128: return 1;
    case 127: return 2;
    default: return 0;
    }
}

/* The same value may appear in an inner switch. */
int on_nest(int x)
{
    switch (x) {
    case 1:
        switch (x) {
        case 1: return 4;
        default: return 5;
        }
    default: return 0;
    }
}

void test_cases(void)
{
    assertEqual(on_int(-32768), 1);
    assertEqual(on_int(32767), 2);
    assertEqual(on_int(0), 3);
    assertEqual(on_int(1), 0);
    assertEqual(on_uint(0), 1);
    assertEqual(on_uint(65535u), 2);
    assertEqual(on_uint(1), 0);
    assertEqual(on_uchar(0), 1);
    assertEqual(on_uchar(255), 2);
    assertEqual(on_uchar(1), 3);
    assertEqual(on_schar(-128), 1);
    assertEqual(on_schar(127), 2);
    assertEqual(on_nest(1), 4);
    assertEqual(on_nest(2), 0);
}

int suite_caserange(void)
{
    suite_setup("Case labels at the type limits");
    suite_add_test(test_cases);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_caserange();
    exit(res);
}
