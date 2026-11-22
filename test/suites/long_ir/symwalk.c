/* Constant stores to nearby bytes of one global step HL instead of reloading
 * the address; stores to other globals, far offsets, and stores after a call
 * must not reuse it. */
#include "test.h"

static unsigned char ta[8];
static unsigned char tb[4];
static unsigned int tw[4];

static void clobber(void)
{
    tb[3] = 9;
}

static void down(void)
{
    ta[0] = ta[1] = ta[2] = ta[3] = 0xff;
}

static void up(void)
{
    ta[4] = 1; ta[5] = 2; ta[6] = 3; ta[7] = 4;
}

static void mixed(void)
{
    ta[3] = 0x33; ta[1] = 0x11; ta[2] = 0x22; ta[0] = 0x00;
    tb[0] = 0xa0; ta[7] = 0x77; tb[1] = 0xa1; ta[6] = 0x66;
}

static void far_and_call(void)
{
    ta[0] = 5;
    ta[7] = 6;
    clobber();
    ta[1] = 7;
    tb[2] = 8;
}

static void words(void)
{
    tw[0] = 0x1234; tw[1] = 0x5678; tw[3] = 0x9abc; tw[2] = 0xdef0;
}

void test_symwalk(void)
{
    int i;
    for (i = 0; i < 8; i++) ta[i] = 0;
    for (i = 0; i < 4; i++) tb[i] = 0;
    down();
    assertEqual(ta[0], 0xff); assertEqual(ta[1], 0xff);
    assertEqual(ta[2], 0xff); assertEqual(ta[3], 0xff);
    assertEqual(ta[4], 0);
    up();
    assertEqual(ta[3], 0xff); assertEqual(ta[4], 1);
    assertEqual(ta[5], 2); assertEqual(ta[6], 3); assertEqual(ta[7], 4);
    mixed();
    assertEqual(ta[0], 0x00); assertEqual(ta[1], 0x11);
    assertEqual(ta[2], 0x22); assertEqual(ta[3], 0x33);
    assertEqual(ta[6], 0x66); assertEqual(ta[7], 0x77);
    assertEqual(tb[0], 0xa0); assertEqual(tb[1], 0xa1);
    far_and_call();
    assertEqual(ta[0], 5); assertEqual(ta[1], 7); assertEqual(ta[7], 6);
    assertEqual(tb[2], 8); assertEqual(tb[3], 9);
    words();
    assertEqual(tw[0], 0x1234); assertEqual(tw[1], 0x5678);
    assertEqual(tw[2], 0xdef0); assertEqual(tw[3], 0x9abc);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant stores to nearby globals");
    suite_add_test(test_symwalk);
    return suite_run();
}
