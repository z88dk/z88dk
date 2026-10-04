/* [dsub-bc] 8085 signed compares with one operand already in BC.
 *
 * DSUB (`sub hl,bc`) subtracts BC. When the left operand is the one in BC,
 * the compare is done as right - left: `l < r` is false exactly on K or Z.
 * When the right operand is in BC, `sub hl,bc` runs on it directly.
 *
 *  - count_up    `for (i = lo; i < n; i++)`, i in BC: left in BC, the exit
 *                branch takes the K-or-Z side. Zero-trip, negative and
 *                near-limit bounds.
 *  - count_ge    `while (i >= n)`, i in BC: left in BC, jump on the true side.
 *  - count_down  `for (i = hi; n < i; i--)`: right in BC.
 *
 * Every CPU builds it; only 8085 rewrites. _keep runs the 8085 opt-out.
 */
#include "test.h"

static int seen;

static void sink(int v)
{
    seen += v;
}

static int count_up(int lo, int n)
{
    int i, c = 0;

    for (i = lo; i < n; i++) {
        sink(1);
        c++;
    }
    return c;
}

static int count_ge(int i, int n)
{
    int c = 0;

    while (i >= n) {
        sink(1);
        i -= 3;
        c++;
    }
    return c;
}

static int count_down(int hi, int n)
{
    int i, c = 0;

    for (i = hi; n < i; i--) {
        sink(1);
        c++;
    }
    return c;
}

static void test_count_up(void)
{
    Assert(count_up(0, 10) == 10, "up 0..10");
    Assert(count_up(0, 0) == 0, "up zero-trip");
    Assert(count_up(0, -5) == 0, "up negative bound");
    Assert(count_up(-3, 2) == 5, "up from negative");
    Assert(count_up(32760, 32767) == 7, "up near max");
    Assert(count_up(-32768, -32765) == 3, "up near min");
    Assert(count_up(5, 5) == 0, "up equal");
}

static void test_count_ge(void)
{
    Assert(count_ge(10, 0) == 4, "ge 10 to 0");
    Assert(count_ge(0, 0) == 1, "ge equal");
    Assert(count_ge(-1, 0) == 0, "ge below");
    Assert(count_ge(-30000, -30005) == 2, "ge negative");
}

static void test_count_down(void)
{
    Assert(count_down(10, 0) == 10, "down 10 to 0");
    Assert(count_down(0, 0) == 0, "down equal");
    Assert(count_down(-5, 0) == 0, "down below");
    Assert(count_down(3, -3) == 6, "down across zero");
    Assert(count_down(-32765, -32768) == 3, "down near min");
}

int suite_dsubbc(void)
{
    suite_setup("dsub-bc");
    suite_add_test(test_count_up);
    suite_add_test(test_count_ge);
    suite_add_test(test_count_down);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_dsubbc();
    exit(res);
}
