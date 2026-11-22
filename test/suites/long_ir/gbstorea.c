/* [gb-store-a] gbz80 stores HL to a word slot as
 *   ld a,l; ld d,h; ld hl,sp+N; ld (hl+),a; ld (hl),d
 * instead of going through DE. A and E change, so both must be dead after.
 *
 *  - across    word values kept in slots across calls, with a byte value
 *              live in A-adjacent code around the stores.
 *  - mixed     a store followed by a byte use of the same value.
 *
 * Every CPU builds it; only gbz80 rewrites. _keep runs the gbz80 opt-out.
 */
#include "test.h"

static unsigned int seen;

static unsigned int bump(unsigned int v)
{
    seen += v;
    return v + 1;
}

static unsigned int across(unsigned int x, unsigned char c)
{
    unsigned int a = x * 3, b = x + 7, d;

    d = bump(a);
    b += bump(b);
    a = bump(d) + c;
    return a + b + d + c;
}

static unsigned int mixed(unsigned int x)
{
    unsigned int a = x + 0x1234;
    unsigned char lo;

    bump(a);
    lo = (unsigned char)a;
    a = bump(a ^ 0x00ff);
    return a + lo;
}

static void test_across(void)
{
    seen = 0;
    Assert(across(10, 5) == 37 + 35 + 31 + 5, "across value");
    Assert(seen == 30 + 17 + 31, "across seen");
}

static void test_mixed(void)
{
    seen = 0;
    Assert(mixed(1) == 0x12cb + 0x35, "mixed value");
    Assert(seen == 0x1235 + 0x12ca, "mixed seen");
}

int suite_gbstorea(void)
{
    suite_setup("gb-store-a");
    suite_add_test(test_across);
    suite_add_test(test_mixed);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_gbstorea();
    exit(res);
}
