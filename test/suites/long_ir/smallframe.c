/* [small-frame-fast] A 4-byte frame is reserved with `ld hl,-4; add hl,sp;
 * ld sp,hl` on z180 and four `dec sp` on ez80/kc160, and 5-byte (any size on
 * kc160) frames are dropped with `pop af` / `inc sp`, keeping HL or DEHL:
 * words live across calls must land in their slots, and the caller's stack
 * must come back intact. */
#include "test.h"

static int acc;
static int bump(int v) { acc += v; return acc; }

static int two_live(int a, int b)
{
    int x = a * 3 + 1;
    int y = b ^ 0x5a5a;
    bump(x);
    bump(y);
    return x - y + bump(1);
}

static long four_bytes(long v)
{
    long w = v + 0x12345L;
    bump((int)v);
    return w ^ (long)bump(2);
}

/* Teardown of a 5-byte frame: `pop af` x2 + `inc sp` (inc sp on ez80/kc160)
   keeps HL. */
static int five_bytes(int a)
{
    int x = a + 1, y = a * 3;
    unsigned char z = (unsigned char)(a ^ 7);
    bump(x);
    bump(y);
    bump(z);
    return x + y + z;
}

static long six_long(long a)
{
    int x = (int)a + 1, y = (int)a * 3, z = (int)a ^ 7;
    bump(x);
    bump(y);
    bump(z);
    return a + x + y + z;
}

static void test_smallframe(void)
{
    acc = 0;
    assertEqual(two_live(7, 100), 45);
    assertEqual(acc, 23125);
    acc = 0;
    assertEqual((int)four_bytes(0x10000L), 9031);
    assertEqual((int)(four_bytes(0x10000L) >> 16), 2);
    acc = 0;
    assertEqual(five_bytes(1000), 4240);
    assertEqual(acc, 4240);
    assertEqual((int)six_long(0x30005L), 28);
    assertEqual((int)(six_long(0x30005L) >> 16), 3);
}

int main(int argc, char *argv[])
{
    suite_setup("smallframe");
    suite_add_test(test_smallframe);
    return suite_run();
}
