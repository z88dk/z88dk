/* sccz80 only. 80cc does not compile a function with this many parameters. */
#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/* 98 arguments is the most one call can carry. p00 is the first,
   p97 is the last. */
#define P(n) int p##n
#define R0 P(0), P(1), P(2), P(3), P(4), P(5), P(6), P(7), P(8), P(9)
#define R(n) P(n##0), P(n##1), P(n##2), P(n##3), P(n##4), P(n##5), P(n##6), P(n##7), P(n##8), P(n##9)

int ends(R0, R(1), R(2), R(3), R(4), R(5), R(6), R(7), R(8), P(90), P(91), P(92), P(93), P(94), P(95), P(96), P(97))
{
    return p0 + p97;
}

#define Z10 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

void test_full_call(void)
{
    assertEqual(ends(20, Z10, Z10, Z10, Z10, Z10, Z10, Z10, Z10, Z10, 0, 0, 0, 0, 0, 0, 22), 42);
}

int suite_callargs(void)
{
    suite_setup("Call argument limit");
    suite_add_test(test_full_call);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_callargs();
    exit(res);
}
