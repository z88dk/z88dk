/* [remat-lea-call] A frame address (&local) rematerialised as an argument
 * while earlier arguments are already pushed must count those pushes: here
 * &pivot is passed to cmp after &v[j] (and a saved BC) are on the stack.
 * The guard that kept remat out of functions with calls is lifted. */
#include "test.h"

static int cmp_int(const void *a, const void *b)
{
    int x = *(const int *)a, y = *(const int *)b;
    return (x > y) - (x < y);
}

static void qsort_rec(int *v, int lo, int hi, int (*cmp)(const void *, const void *))
{
    int i, j, pivot, tmp;
    if (lo >= hi) return;
    pivot = v[hi];
    i = lo;
    for (j = lo; j < hi; j++) {
        if (cmp(&v[j], &pivot) < 0) {
            tmp = v[i]; v[i] = v[j]; v[j] = tmp;
            i++;
        }
    }
    tmp = v[i]; v[i] = v[hi]; v[hi] = tmp;
    qsort_rec(v, lo, i - 1, cmp);
    qsort_rec(v, i + 1, hi, cmp);
}

static int two(int *a, int k, int *b) { return *a * 3 + k + *b; }

static int caller(int x)
{
    int p = x, q = x + 1;
    return two(&p, 5, &q) + two(&q, p, &p);
}

static void test_remacall(void)
{
    int v[24], i;
    unsigned int s = 0x1234u;
    for (i = 0; i < 24; i++) { s = s * 25173u + 13849u; v[i] = (int)(s & 0x3ff) - 512; }
    qsort_rec(v, 0, 23, cmp_int);
    for (i = 1; i < 24; i++) assertEqual(v[i - 1] <= v[i], 1);
    assertEqual(caller(7), 7 * 3 + 5 + 8 + 8 * 3 + 7 + 7);
}

int main(int argc, char *argv[])
{
    suite_setup("remacall");
    suite_add_test(test_remacall);
    return suite_run();
}
