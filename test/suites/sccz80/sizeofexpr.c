#include "test.h"
#include <stdio.h>
#include <stdlib.h>

int a[4];
int row[3][4];
int *p;
int n;
int calls;

int f(void)
{
    calls++;
    return 7;
}

long fl(void)
{
    calls++;
    return 9;
}

int bump(void)
{
    calls++;
    return 0;
}

int old_sizes(void)
{
    /* 2 + 8 + 2 + 2 + 2 */
    return sizeof(int) + sizeof(a) + sizeof(*p) + sizeof(a[1]) + sizeof(n);
}

#ifndef __80CC
int new_sizes(void)
{
    char buf[sizeof(1 + 2)];

    /* 2 + 2 + 4 + 2 + 8 + 2 + 2 + 2 + 2 */
    return sizeof(1 + 2) + sizeof(f()) + sizeof(fl()) + sizeof(a[n])
         + sizeof(row[n]) + sizeof(*p + 1) + sizeof(p[n]) + sizeof(buf)
         + (int)sizeof(sizeof(int));
}

void test_unevaluated(void)
{
    calls = 0;
    n = 3;
    assertEqual((int)sizeof(f()), 2);
    assertEqual((int)sizeof(fl()), 4);
    assertEqual((int)sizeof(a[bump()]), 2);
    assertEqual((int)sizeof(a[n]), 2);
    assertEqual((int)sizeof(row[n]), 8);
    assertEqual((int)sizeof(*p + 1), 2);
    assertEqual(calls, 0);
    assertEqual(n, 3);
}
#endif

void test_sizes(void)
{
    assertEqual(old_sizes(), 16);
#ifndef __80CC
    assertEqual(new_sizes(), 26);
#endif
}

int suite_sizeofexpr(void)
{
    suite_setup("sizeof expression");
    suite_add_test(test_sizes);
#ifndef __80CC
    suite_add_test(test_unevaluated);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_sizeofexpr();
    exit(res);
}
