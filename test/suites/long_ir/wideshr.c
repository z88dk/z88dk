/* A byte taken from a 32-bit right shift by a count that is not a multiple of 8. */
#include "test.h"

static unsigned char sh3(unsigned long x) { return (unsigned char)(x >> 3); }
static unsigned char sh5(unsigned long x) { return (unsigned char)(x >> 5); }
static unsigned char sh13(unsigned long x) { return (unsigned char)(x >> 13); }
static unsigned char sh19(unsigned long x) { return (unsigned char)(x >> 19); }
static unsigned char sh21(unsigned long x) { return (unsigned char)(x >> 21); }
static unsigned char pages(unsigned long x) { return (unsigned char)(x / 0x2000) + (unsigned char)((x % 0x2000 == 0) ? 0 : 1); }

void test_wideshr(void)
{
    assertEqual(sh3(0x0UL), 0);
    assertEqual(sh5(0x0UL), 0);
    assertEqual(sh13(0x0UL), 0);
    assertEqual(sh19(0x0UL), 0);
    assertEqual(sh21(0x0UL), 0);
    assertEqual(pages(0x0UL), 0);
    assertEqual(sh3(0x1UL), 0);
    assertEqual(sh5(0x1UL), 0);
    assertEqual(sh13(0x1UL), 0);
    assertEqual(sh19(0x1UL), 0);
    assertEqual(sh21(0x1UL), 0);
    assertEqual(pages(0x1UL), 1);
    assertEqual(sh3(0x1fffUL), 255);
    assertEqual(sh5(0x1fffUL), 255);
    assertEqual(sh13(0x1fffUL), 0);
    assertEqual(sh19(0x1fffUL), 0);
    assertEqual(sh21(0x1fffUL), 0);
    assertEqual(pages(0x1fffUL), 1);
    assertEqual(sh3(0x2000UL), 0);
    assertEqual(sh5(0x2000UL), 0);
    assertEqual(sh13(0x2000UL), 1);
    assertEqual(sh19(0x2000UL), 0);
    assertEqual(sh21(0x2000UL), 0);
    assertEqual(pages(0x2000UL), 1);
    assertEqual(sh3(0x2001UL), 0);
    assertEqual(sh5(0x2001UL), 0);
    assertEqual(sh13(0x2001UL), 1);
    assertEqual(sh19(0x2001UL), 0);
    assertEqual(sh21(0x2001UL), 0);
    assertEqual(pages(0x2001UL), 2);
    assertEqual(sh3(0x12345678UL), 207);
    assertEqual(sh5(0x12345678UL), 179);
    assertEqual(sh13(0x12345678UL), 162);
    assertEqual(sh19(0x12345678UL), 70);
    assertEqual(sh21(0x12345678UL), 145);
    assertEqual(pages(0x12345678UL), 163);
    assertEqual(sh3(0xffffffffUL), 255);
    assertEqual(sh5(0xffffffffUL), 255);
    assertEqual(sh13(0xffffffffUL), 255);
    assertEqual(sh19(0xffffffffUL), 255);
    assertEqual(sh21(0xffffffffUL), 255);
    assertEqual(pages(0xffffffffUL), 0);
    assertEqual(sh3(0x80000000UL), 0);
    assertEqual(sh5(0x80000000UL), 0);
    assertEqual(sh13(0x80000000UL), 0);
    assertEqual(sh19(0x80000000UL), 0);
    assertEqual(sh21(0x80000000UL), 0);
    assertEqual(pages(0x80000000UL), 0);
    assertEqual(sh3(0xffe000UL), 0);
    assertEqual(sh5(0xffe000UL), 0);
    assertEqual(sh13(0xffe000UL), 255);
    assertEqual(sh19(0xffe000UL), 31);
    assertEqual(sh21(0xffe000UL), 7);
    assertEqual(pages(0xffe000UL), 255);
    assertEqual(sh3(0xdeadbeefUL), 221);
    assertEqual(sh5(0xdeadbeefUL), 247);
    assertEqual(sh13(0xdeadbeefUL), 109);
    assertEqual(sh19(0xdeadbeefUL), 213);
    assertEqual(sh21(0xdeadbeefUL), 245);
    assertEqual(pages(0xdeadbeefUL), 110);
    assertEqual(sh3(0xa5a5a5UL), 180);
    assertEqual(sh5(0xa5a5a5UL), 45);
    assertEqual(sh13(0xa5a5a5UL), 45);
    assertEqual(sh19(0xa5a5a5UL), 20);
    assertEqual(sh21(0xa5a5a5UL), 5);
    assertEqual(pages(0xa5a5a5UL), 46);
    assertEqual(sh3(0x1000000UL), 0);
    assertEqual(sh5(0x1000000UL), 0);
    assertEqual(sh13(0x1000000UL), 0);
    assertEqual(sh19(0x1000000UL), 32);
    assertEqual(sh21(0x1000000UL), 8);
    assertEqual(pages(0x1000000UL), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte from a wide shift");
    suite_add_test(test_wideshr);
    return suite_run();
}
