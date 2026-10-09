/* Word accumulator kept in DE across a loop and read after it.
 *
 * The loop-exit block used to flush the accumulator to its frame slot and
 * reload it for the return. When the exit block only returns, the slot is
 * never read, so the flush is deferred; the first op that clobbers DE (a
 * call, more arithmetic) must still flush before it, and a loop whose exit
 * is NOT the return keeps the flush because later code may read the slot.
 *
 *  - sum_ret:       the plain shape — exit block returns the accumulator.
 *  - sum_call:      exit block calls a function first; DE is clobbered by the
 *                   call, so the accumulator must survive it via its slot.
 *  - sum_two:       two loops share one accumulator; the first exit is not a
 *                   return, so it must still flush.
 *  - sum_branch:    exit block decides between two returns.
 *  - sum_empty:     zero-trip loop returns the initial value.
 *
 * Self-verifying against sums computed by hand.
 */
#include "test.h"

static int arr[8] = { 3, -7, 11, 100, -2, 5, 1000, -300 };

static int add3(int x) { return x + 3; }

static int sum_ret(int *a, int n)
{
    int i, sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    return sum;
}

static int sum_call(int *a, int n)
{
    int i, sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    return sum + add3(sum);
}

static int sum_two(int *a, int n)
{
    int i, sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    for (i = 0; i < n; i++) sum += a[i] * 2;
    return sum;
}

static int sum_branch(int *a, int n)
{
    int i, sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    if (sum > 500) return sum - 500;
    return sum;
}

static int sum_empty(int *a, int n)
{
    int i, sum = 77;
    for (i = 0; i < n; i++) sum += a[i];
    return sum;
}

static void test_homeexit(void)
{
    Assert(sum_ret(arr, 8) == 810, "sum_ret all");
    Assert(sum_ret(arr, 4) == 107, "sum_ret first four");
    Assert(sum_ret(arr, 0) == 0, "sum_ret empty");
    Assert(sum_ret(arr, -3) == 0, "sum_ret negative count");

    Assert(sum_call(arr, 8) == 810 + 813, "sum_call all");
    Assert(sum_call(arr, 3) == 7 + 10, "sum_call first three");

    Assert(sum_two(arr, 8) == 810 * 3, "sum_two all");
    Assert(sum_two(arr, 2) == -4 * 3, "sum_two first two");

    Assert(sum_branch(arr, 8) == 310, "sum_branch big");
    Assert(sum_branch(arr, 4) == 107, "sum_branch small");

    Assert(sum_empty(arr, 0) == 77, "sum_empty zero trips");
    Assert(sum_empty(arr, 2) == 73, "sum_empty two");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("DE accumulator read after its loop");
    suite_add_test(test_homeexit);
    return suite_run();
}
