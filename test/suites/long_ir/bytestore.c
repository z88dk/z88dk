/* A byte taken from a long and kept across a call is stored to its frame slot
 * straight from the register that holds it. All four bytes are checked.
 */
#include "test.h"

static unsigned char sink;
static void keep(unsigned char v) { sink += v; }

static unsigned long reverse(unsigned long v)
{
    unsigned char b0 = (unsigned char)v;
    unsigned char b1 = (unsigned char)(v >> 8);
    unsigned char b2 = (unsigned char)(v >> 16);
    unsigned char b3 = (unsigned char)(v >> 24);
    keep(b0);
    keep(b3);
    return ((unsigned long)b0 << 24) | ((unsigned long)b1 << 16)
         | ((unsigned long)b2 << 8) | b3;
}

static void check(void)
{
    assertEqual(reverse(0x11223344UL), 0x44332211UL);
    assertEqual(sink, (unsigned char)(0x44 + 0x11));
    assertEqual(reverse(0xA1B2C3D4UL), 0xD4C3B2A1UL);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte of a long stored from a register");
    suite_add_test(check);
    return suite_run();
}
