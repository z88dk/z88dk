/* [hl-mem-carry] A global word loaded for a test is still in HL in the block
 * the test branches to, so a reload of the same word there is dropped.
 * [block-layout-rounds] A moved trace may end in a jump that another move
 * replaced; layout repeats until the text is stable.
 *
 *  - call_hooks   `if (h.pre) h.pre();` and `if (h.post) h.post();`: the
 *                 reload before the indirect call goes.
 *  - store_between the global is rewritten between test and reuse: the
 *                 reload must stay.
 *  - two_paths    a block reached from two tests of DIFFERENT globals: no
 *                 carry.
 *  - in_loop      the hook test inside a loop with a counter increment
 *                 (the chained layout case).
 *
 * Every CPU builds it. _keep runs both opt-outs.
 */
#include "test.h"

struct hooks {
    int n;
    void (*pre)(void);
    void (*post)(void);
};

static struct hooks h;
static int g1, g2, seen;

static void bump(void)
{
    seen++;
}

static void bump10(void)
{
    seen += 10;
}

static void call_hooks(void)
{
    if (h.pre)
        h.pre();
    seen += 100;
    if (h.post)
        h.post();
}

static int store_between(int v)
{
    if (g1) {
        g1 = v;
        return g1 + 1;
    }
    return -1;
}

static int two_paths(int which)
{
    int r;

    if (which) {
        if (g1)
            goto use;
        return 0;
    } else {
        if (g2)
            goto use;
        return 0;
    }
use:
    r = g1 * 10 + g2;
    return r;
}

static int in_loop(int n)
{
    int i, c = 0;

    for (i = 0; i < n; i++) {
        if (h.pre)
            h.pre();
        c++;
        if (h.post)
            h.post();
    }
    return c;
}

static void test_call_hooks(void)
{
    seen = 0;
    h.pre = 0; h.post = 0;
    call_hooks();
    Assert(seen == 100, "no hooks");
    h.pre = bump;
    call_hooks();
    Assert(seen == 201, "pre only");
    h.post = bump10;
    call_hooks();
    Assert(seen == 312, "both");
    h.pre = 0;
    call_hooks();
    Assert(seen == 422, "post only");
}

static void test_store_between(void)
{
    g1 = 5;
    Assert(store_between(7) == 8, "rewritten global reread");
    g1 = 0;
    Assert(store_between(7) == -1, "zero global");
}

static void test_two_paths(void)
{
    g1 = 3; g2 = 4;
    Assert(two_paths(1) == 34, "path g1");
    Assert(two_paths(0) == 34, "path g2");
    g1 = 0;
    Assert(two_paths(1) == 0, "g1 zero");
    Assert(two_paths(0) == 4, "g2 path, g1 zero");
}

static void test_in_loop(void)
{
    seen = 0;
    h.pre = bump; h.post = bump10;
    Assert(in_loop(5) == 5, "loop count");
    Assert(seen == 55, "loop hooks");
    h.pre = 0;
    seen = 0;
    Assert(in_loop(3) == 3, "loop count 2");
    Assert(seen == 30, "loop post only");
}

int suite_hlmemcarry(void)
{
    suite_setup("hl-mem-carry");
    suite_add_test(test_call_hooks);
    suite_add_test(test_store_between);
    suite_add_test(test_two_paths);
    suite_add_test(test_in_loop);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_hlmemcarry();
    exit(res);
}
