#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/* One step is a few dozen bytes of assembly. Five hundred of them
   overflow a one-block statement buffer and force it to grow. */
#define S1 n = n + 1
#define S10 S1, S1, S1, S1, S1, S1, S1, S1, S1, S1
#define S100 S10, S10, S10, S10, S10, S10, S10, S10, S10, S10
#define S500 S100, S100, S100, S100, S100

/* Eight thousand steps stay inside one input line and are about
   300 KB of assembly. Three of those pass the 700 KB body buffer. */
#define A n++;
#define B A A A A A A A A A A
#define C B B B B B B B B B B
#define D C C C C C C C C C C
#define F D D D D D D D D

static int n;

void test_grow_increment(void)
{
    n = 0;
    for (; n < 1; S500)
        ;
    assertEqual(n, 500);
}

void test_false_for(void)
{
    int v;

    v = 1;
    n = 0;
    for (; 0; S500)
        v = 8;
    assertEqual(v, 1);
    assertEqual(n, 0);
}

#ifndef __80CC
void test_wide_discard(void)
{
    int v;

    v = 1;
    n = 0;
    for (; 0; n = n + 1) {
        F
        F
        F
    }
    if (0) {
        F
    }
    assertEqual(v, 1);
    assertEqual(n, 0);
}
#endif

int suite_bufgrow(void)
{
    suite_setup("Statement buffer growth");
    suite_add_test(test_grow_increment);
    suite_add_test(test_false_for);
#ifndef __80CC
    suite_add_test(test_wide_discard);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_bufgrow();
    exit(res);
}
