#include "test.h"
#include <stdio.h>
#include <stdlib.h>

static int seen;

static void mark(void)
{
    seen = 1;
}

void test_if_constants(void)
{
    int v;

    seen = 0;
    if (2)
        mark();
    assertEqual(seen, 1);

    seen = 0;
    if (0.5)
        mark();
    assertEqual(seen, 1);

    seen = 0;
    if (-1)
        mark();
    assertEqual(seen, 1);

    seen = 0;
    if (1)
        mark();
    assertEqual(seen, 1);

    seen = 0;
    if (0)
        mark();
    assertEqual(seen, 0);

    v = 0;
    if (0)
        v = 1;
    else
        v = 2;
    assertEqual(v, 2);
}

void test_loops(void)
{
    int n;

    n = 0;
    while (0)
        n++;
    assertEqual(n, 0);

    n = 0;
    while (0.5) {
        n++;
        break;
    }
    assertEqual(n, 1);

    n = 0;
    do {
        n++;
    } while (0);
    assertEqual(n, 1);

    n = 0;
    for (; 0.5; ) {
        n++;
        break;
    }
    assertEqual(n, 1);

    n = 0;
    for (; 0; )
        n++;
    assertEqual(n, 0);
}

/* This must still be compiled. if (2) used to discard the rest of the file. */
int trailing(void)
{
    return 7;
}

void test_trailing(void)
{
    assertEqual(trailing(), 7);
}

int suite_constif(void)
{
    suite_setup("Constant conditions");
    suite_add_test(test_if_constants);
    suite_add_test(test_loops);
    suite_add_test(test_trailing);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_constif();
    exit(res);
}
