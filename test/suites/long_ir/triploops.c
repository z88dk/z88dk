/* Constant loop bounds: the T-state estimator weights a loop by its trip count when the
 * compiler can work it out (a counter set from a constant, stepped by a constant, tested
 * against a constant). The Makefile checks the counts the compiler reports; this program
 * checks the loops still compute the right values.
 */
#include "test.h"

static int a[64];

/* 100 trips. */
static int cnt_for(void)
{
    int i, s = 0;
    for (i = 0; i < 100; i++) s += i;
    return s;
}

/* 10 trips, tested after the step. */
static int cnt_down(void)
{
    unsigned char i = 10;
    int s = 0;
    do { s += i; } while (--i);
    return s;
}

/* 3 outer trips, 50 inner. */
static int cnt_nested(void)
{
    int r, i, s = 0;
    for (r = 0; r < 3; r++)
        for (i = 0; i < 100; i += 2) s += r;
    return s;
}

/* A second way out makes the bound a ceiling, so the count is halved and capped at 8. */
static int cnt_early(int k)
{
    int i;
    for (i = 0; i < 64; i++)
        if (a[i] == k) return i;
    return -1;
}

/* No constant bound: no count. */
static int cnt_var(int n)
{
    int i, s = 0;
    for (i = 0; i < n; i++) s += a[i];
    return s;
}

static void trip_run(void)
{
    int i;
    for (i = 0; i < 64; i++) a[i] = i * 3;

    Assert(cnt_for() == 4950, "constant for loop");
    Assert(cnt_down() == 55, "constant do-while countdown");
    Assert(cnt_nested() == 150, "nested constant loops");
    Assert(cnt_early(21) == 7, "constant loop with a second exit, found");
    Assert(cnt_early(1000) == -1, "constant loop with a second exit, not found");
    Assert(cnt_var(10) == 135, "loop with a variable bound");
}

int suite_trip(void)
{
    suite_setup("Constant loop bound Tests");
    suite_add_test(trip_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_trip();
    exit(res);
}
