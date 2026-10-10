/* Long ordered compares with both operands in the frame: every pair of a sorted
 * array must compare as its indices do, signed and unsigned, with the operands
 * as parameters and as copies in locals.
 */
#include "test.h"

#define N 9

static const long sv[N] = { -2147483647L - 1, -65537L, -65536L, -2L, 0L, 1L, 65535L, 65536L, 2147483647L };
static const unsigned long uv[N] = { 0UL, 1UL, 255UL, 256UL, 65535UL, 65536UL, 0x7FFFFFFFUL, 0x80000000UL, 0xFFFFFFFFUL };

static int s_lt(long a, long b)  { return a < b; }
static int s_le(long a, long b)  { return a <= b; }
static int s_gt(long a, long b)  { return a > b; }
static int s_ge(long a, long b)  { return a >= b; }
static int u_lt(unsigned long a, unsigned long b) { return a < b; }
static int u_ge(unsigned long a, unsigned long b) { return a >= b; }
static int s_lt_loc(long x, long y)
{
    long a = x, b = y;
    int r = 0;
    if (a < b) r = 1;
    return r;
}
static int u_gt_loc(unsigned long x, unsigned long y)
{
    unsigned long a = x, b = y;
    if (a > b) return 1;
    return 0;
}

static void check(void)
{
    int i, j;

    for (i = 0; i < N; i++)
        for (j = 0; j < N; j++) {
            assertEqual(s_lt(sv[i], sv[j]), i < j);
            assertEqual(s_le(sv[i], sv[j]), i <= j);
            assertEqual(s_gt(sv[i], sv[j]), i > j);
            assertEqual(s_ge(sv[i], sv[j]), i >= j);
            assertEqual(u_lt(uv[i], uv[j]), i < j);
            assertEqual(u_ge(uv[i], uv[j]), i >= j);
            assertEqual(s_lt_loc(sv[i], sv[j]), i < j);
            assertEqual(u_gt_loc(uv[i], uv[j]), i > j);
        }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long ordered compare of two frame operands");
    suite_add_test(check);
    return suite_run();
}
