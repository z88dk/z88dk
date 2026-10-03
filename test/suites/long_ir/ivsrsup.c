/* [ivsr-suppress] two arrays walked by one signed index.
 *
 * Where the index stays live (two array reads plus the exit test), IVSR
 * keeps the index and recomputes each address instead of stepping a
 * second pointer. The signed exit test must then still see n <= 0 as a
 * zero-trip loop.
 *
 *  - bdot   byte arrays, scale 1.
 *  - wdot   word arrays, scale 2: each address recomputes i*2
 *          (ivsr-recompute; _rckeep shares it).
 *  - waxpy  word read-modify-write of one array from another.
 *
 * Every CPU builds it; _keep runs the opt-out on the CPUs it gates.
 */
#include "test.h"

#define N 24

static unsigned char bx[N], by[N];
static unsigned int wx[N], wy[N];

static unsigned int bdot(int n)
{
    unsigned int s = 0;
    int i;

    for (i = 0; i < n; i++)
        s += (unsigned int)bx[i] * by[i];
    return s;
}

static unsigned int wdot(int n)
{
    unsigned int s = 0;
    int i;

    for (i = 0; i < n; i++)
        s += wx[i] * wy[i];
    return s;
}

static void waxpy(int n, unsigned int a)
{
    int i;

    for (i = 0; i < n; i++)
        wy[i] = a * wx[i] + wy[i];
}

static void fill(void)
{
    int i;

    for (i = 0; i < N; i++) {
        bx[i] = i + 1;
        by[i] = 2;
        wx[i] = i + 1;
        wy[i] = 3;
    }
}

static void test_bdot(void)
{
    fill();
    Assert(bdot(N) == N * (N + 1), "bdot full");
    Assert(bdot(5) == 30, "bdot part");
    Assert(bdot(0) == 0, "bdot zero");
    Assert(bdot(-3) == 0, "bdot negative");
}

static void test_wdot(void)
{
    fill();
    Assert(wdot(N) == 3 * N * (N + 1) / 2, "wdot full");
    Assert(wdot(4) == 30, "wdot part");
    Assert(wdot(0) == 0, "wdot zero");
    Assert(wdot(-1) == 0, "wdot negative");
}

static void test_waxpy(void)
{
    fill();
    waxpy(-5, 7);
    Assert(wy[0] == 3, "waxpy negative");
    waxpy(3, 2);
    Assert(wy[0] == 5 && wy[2] == 9 && wy[3] == 3, "waxpy part");
}

int suite_ivsrsup(void)
{
    suite_setup("ivsr-suppress");
    suite_add_test(test_bdot);
    suite_add_test(test_wdot);
    suite_add_test(test_waxpy);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_ivsrsup();
    exit(res);
}
