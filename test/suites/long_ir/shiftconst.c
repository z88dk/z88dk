/* A constant shifted by a variable count: the value is the same with the
 * constant loaded straight into the shifter or through HL. */
#include "test.h"

static volatile unsigned char *ptr;
static unsigned char buf[2];

static unsigned int shl_u8(unsigned char n)
{
    return 1 << n;
}

static unsigned int shl_i(unsigned int n)
{
    return 0x0123 << n;
}

static unsigned int shr_i(unsigned int n)
{
    return 0xa5a5u >> n;
}

static int shr_s(unsigned int n)
{
    return -1024 >> n;
}

static void bit_ops(unsigned char b, unsigned char a)
{
    ptr = buf;
    if (b == 0x40)
        buf[0] ^= (1 << a);
    if (b == 0x80)
        buf[0] &= ((1 << a) ^ 0xff);
    if (b == 0xc0)
        buf[0] |= (1 << a);
}

void test_shiftconst(void)
{
    assertEqual(shl_u8(0), 1);
    assertEqual(shl_u8(7), 128);
    assertEqual(shl_u8(15), 0x8000u);
    assertEqual(shl_i(4), 0x1230);
    assertEqual(shr_i(0), 0xa5a5u);
    assertEqual(shr_i(4), 0x0a5a);
    assertEqual(shr_i(12), 0x000a);
    assertEqual(shr_s(3), -128);
    assertEqual(shr_s(10), -1);
    buf[0] = 0;
    bit_ops(0xc0, 3);
    assertEqual(buf[0], 8);
    bit_ops(0xc0, 0);
    assertEqual(buf[0], 9);
    bit_ops(0x40, 3);
    assertEqual(buf[0], 1);
    bit_ops(0x80, 0);
    assertEqual(buf[0], 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("shift of a constant");
    suite_add_test(test_shiftconst);
    return suite_run();
}
