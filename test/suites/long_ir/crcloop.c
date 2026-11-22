/* A long carried through a counted loop: the bit-serial CRC-16 shift/xor on a
 * long that lives on the stack, and byte-narrowed down-counters tested at the
 * bottom of the loop (seeds 1, 255 and 256: 256 does not fit a byte and must
 * keep its sixteen bits).
 */
#include "test.h"

static unsigned int crc16(const unsigned char *p, unsigned int n)
{
    unsigned int crc = 0xffffu, i;
    unsigned long x;

    while (n--) {
        x = ((unsigned long)crc << 8) + *p++;
        for (i = 0; i < 8; i++) {
            x = x << 1;
            if (x & 0x01000000UL)
                x = x ^ 0x01102100UL;
        }
        crc = (unsigned int)((x & 0x00ffff00UL) >> 8);
    }
    return crc;
}

static unsigned int trips(unsigned int seed)
{
    unsigned int i = seed, n = 0;
    do { n++; } while (--i);
    return n;
}

static void check(void)
{
    static const unsigned char msg[] = "123456789";
    assertEqual(crc16(msg, 9), 0xa69du);
    assertEqual(trips(1), 1u);
    assertEqual(trips(8), 8u);
    assertEqual(trips(255), 255u);
    assertEqual(trips(256), 256u);
    assertEqual(trips(1000), 1000u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long carried through a counted loop");
    suite_add_test(check);
    return suite_run();
}
