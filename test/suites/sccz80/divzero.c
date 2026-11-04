#include "test.h"
#include <stdio.h>
#include <stdlib.h>

int x = 1 / 0;
int y = 1 % 0;
unsigned ux = 1u / 0u;
unsigned uy = 1u % 0u;
long lx = 1L / 0L;
long ly = 1L % 0L;
long long llx = 1LL / 0LL;
long long lly = 1LL % 0LL;

int runtime_div(int n)
{
    return n / 0;
}

int runtime_mod(int n)
{
    return n % 0;
}

void test_divzero(void)
{
    assertEqual(x, 0);
    assertEqual(y, 0);
    assertEqual(ux, 0);
    assertEqual(uy, 0);
    assertEqual(lx, 0L);
    assertEqual(ly, 0L);
    assertEqual(llx, 0LL);
    assertEqual(lly, 0LL);
    assertEqual(runtime_div(1), 0);
    assertEqual(runtime_mod(1), 0);
    assertEqual(100 / 3, 33);
    assertEqual(100 % 3, 1);
}

int suite_divzero(void)
{
    suite_setup("Division by constant zero");
    suite_add_test(test_divzero);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_divzero();
    exit(res);
}
