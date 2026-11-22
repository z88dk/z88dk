/* eZ80 frame allocation: IX was set before the fastcall auto-push.
   The LEA displacement uses the full frame size. Frames outside the signed
   byte range keep the SP-relative allocation. */
#include "test.h"

static unsigned char seen;

void touch_leapro(unsigned char *p)
{
    seen = p[0];
    p[0]++;
}

static int plain_small(int x)
{
    unsigned char a[7];
    a[0] = x;
    touch_leapro(a);
    return a[0];
}

static int plain_edge(int x)
{
    unsigned char a[125];
    a[0] = x;
    touch_leapro(a);
    return a[0];
}

static int plain_large(int x)
{
    unsigned char a[127];
    a[126] = x;
    touch_leapro(&a[126]);
    return a[126];
}

static long pushed_long(long x) __z88dk_fastcall
{
    unsigned char a[9];
    a[0] = x;
    touch_leapro(a);
    return x + a[0];
}

void test_leapro(void)
{
    assertEqual(plain_small(5), 6);
    assertEqual(plain_edge(7), 8);
    assertEqual(plain_large(9), 10);
    assertEqual(pushed_long(0x12340002L), 0x12340005L);
    assertEqual(seen, 2);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("ez80 frame prologue lea");
    suite_add_test(test_leapro);
    return suite_run();
}
