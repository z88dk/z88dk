/* [gb-small-frame] gbz80 frames of 1 or 2 bytes.
 *
 * A 2-byte frame opens with `push af` and closes with `pop bc`; a 1-byte
 * frame opens with `dec sp` and closes with `inc sp`. The return value
 * (HL / DEHL) must survive the close, and a callee-cleanup function must
 * still strip its arguments.
 *
 *  - word2     2-byte frame, int return.
 *  - long2     2-byte frame, long return in DEHL.
 *  - byte1     1-byte frame, char return.
 *  - callee2   2-byte frame, __z88dk_callee.
 *  - tail4     a 4-argument call right before the return: its `add sp`
 *              cleanup folds with the frame close instead.
 *
 * Every CPU builds it; only gbz80 changes. _keep runs the gbz80 opt-out.
 */
#include "test.h"

static unsigned int seen;

static void sink(unsigned int v)
{
    seen += v;
}

static unsigned int four(unsigned int a, unsigned int b, unsigned int c,
                         unsigned int d)
{
    return a + b * 2 + c * 3 + d * 4;
}

static unsigned int word2(unsigned int x)
{
    unsigned int t = x * 3;

    sink(x);
    sink(t);
    return t + x;
}

static unsigned long long2(unsigned long x)
{
    volatile unsigned int t = (unsigned int)x + 7;

    sink(t);
    sink(t + 1);
    return x + t;
}

static unsigned char byte1(unsigned char c)
{
    unsigned char k = c + 1;

    sink(c);
    sink(k);
    return k ^ c;
}

static unsigned int callee2(unsigned int a, unsigned int b) __z88dk_callee
{
    volatile unsigned int t = a - b;

    sink(a);
    sink(t);
    return t + b * 5;
}

static unsigned int tail4(unsigned int x)
{
    volatile unsigned int t = x + 9;

    sink(t);
    return four(t, x, t, x);
}

static void test_word2(void)
{
    seen = 0;
    Assert(word2(100) == 400, "word2 value");
    Assert(seen == 400, "word2 seen");
}

static void test_long2(void)
{
    seen = 0;
    Assert(long2(0x12345678UL) == 0x12345678UL + 0x567f, "long2 value");
    Assert(seen == 0x567f * 2 + 1, "long2 seen");
}

static void test_byte1(void)
{
    seen = 0;
    Assert(byte1(0x41) == (0x42 ^ 0x41), "byte1 value");
    Assert(seen == 0x83, "byte1 seen");
}

static void test_callee2(void)
{
    unsigned int r;

    seen = 0;
    r = callee2(50, 8);
    Assert(r == 82, "callee2 value");
    Assert(seen == 92, "callee2 seen");
    r = callee2(r, 2) + callee2(9, 9);
    Assert(r == 90 + 45, "callee2 twice");
}

static void test_tail4(void)
{
    seen = 0;
    Assert(tail4(1) == 10 + 2 + 30 + 4, "tail4 value");
    Assert(seen == 10, "tail4 seen");
}

int suite_gbsmallframe(void)
{
    suite_setup("gb-small-frame");
    suite_add_test(test_word2);
    suite_add_test(test_long2);
    suite_add_test(test_byte1);
    suite_add_test(test_callee2);
    suite_add_test(test_tail4);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_gbsmallframe();
    exit(res);
}
