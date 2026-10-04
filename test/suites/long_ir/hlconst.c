/* [hl-const-reuse] A constant loaded into HL while HL already holds a known
 * constant becomes nothing (same value), `inc hl` / `dec hl` (one apart, not
 * on 8085), or a single-byte load (`ld l,n` / `ld h,n`). Runs of constant
 * argument pushes are the main source.
 *
 *  - same      the same constant pushed several times.
 *  - steps     constants one apart, both directions, across 0xffff <-> 0.
 *  - bytes     same high byte, then same low byte.
 *  - mixed     a long chain of word and byte arguments.
 *  - branch    a constant reload after a label must not trust the value
 *              from the other path.
 *
 * Every CPU builds it. _keep runs the opt-out.
 */
#include "test.h"

static unsigned int sum4(unsigned int a, unsigned int b, unsigned int c,
                         unsigned int d)
{
    return a * 1000u + b * 100u + c * 10u + d;
}

static unsigned int mix4(unsigned int a, unsigned int b, unsigned int c,
                         unsigned int d)
{
    return (a ^ 0x1111u) + (b ^ 0x2222u) + (c ^ 0x4444u) + (d ^ 0x8888u);
}

static unsigned char bytes3(unsigned char a, unsigned char b, unsigned char c)
{
    return (unsigned char)(a + b * 3 + c * 7);
}

static void test_same(void)
{
    Assert(sum4(5, 5, 5, 5) == 5555u, "5555");
    Assert(sum4(0, 0, 0, 0) == 0u, "0000");
}

static void test_steps(void)
{
    Assert(sum4(1, 2, 3, 4) == 1234u, "up");
    Assert(sum4(4, 3, 2, 1) == 4321u, "down");
    Assert(mix4(0xffffu, 0u, 0xffffu, 0xfffeu)
           == (0xeeeeu + 0x2222u + 0xbbbbu + 0x7776u), "wrap");
}

static void test_bytes(void)
{
    Assert(mix4(0x1234u, 0x1256u, 0x1278u, 0x3478u)
           == ((0x1234u ^ 0x1111u) + (0x1256u ^ 0x2222u)
               + (0x1278u ^ 0x4444u) + (0x3478u ^ 0x8888u)), "hi then lo");
    Assert(bytes3(7, 9, 200) == (unsigned char)(7 + 27 + 1400), "bytes");
}

static void test_mixed(void)
{
    Assert(sum4(9, 8, 8, 9) == 9889u, "9889");
    Assert(bytes3(1, 2, 3) == 28, "1 2 3");
    Assert(bytes3(3, 3, 3) == 33, "3 3 3");
    Assert(mix4(0x100u, 0x101u, 0x1u, 0x100u)
           == ((0x100u ^ 0x1111u) + (0x101u ^ 0x2222u)
               + (0x1u ^ 0x4444u) + (0x100u ^ 0x8888u)), "mixed");
}

static unsigned int branch(int sel)
{
    unsigned int r;

    if (sel)
        r = sum4(1, 2, 3, 4);
    else
        r = sum4(7, 7, 7, 7);
    return r + sum4(2, 2, 2, 2);
}

static void test_branch(void)
{
    Assert(branch(1) == 1234u + 2222u, "taken");
    Assert(branch(0) == 7777u + 2222u, "not taken");
}

int suite_hlconst(void)
{
    suite_setup("hl-const-reuse");
    suite_add_test(test_same);
    suite_add_test(test_steps);
    suite_add_test(test_bytes);
    suite_add_test(test_mixed);
    suite_add_test(test_branch);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_hlconst();
    exit(res);
}
