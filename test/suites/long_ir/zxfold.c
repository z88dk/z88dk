/* A zero-extended word or byte in a long AND/OR/XOR: in frame-pointer mode the
 * operation reads the word's bytes from the frame and treats the bytes above
 * them as zero. Results are kept live across a call so the destination is a
 * slot as well as a register.
 */
#include "test.h"

static unsigned long sink;
static void keep(unsigned long v) { sink = v; }

static unsigned long wxor(unsigned long x, unsigned int w) { return (unsigned long)w ^ x; }
static unsigned long wand(unsigned long x, unsigned int w) { return x & (unsigned long)w; }
static unsigned long wor(unsigned long x, unsigned int w) { return (unsigned long)w | x; }
static unsigned long bxor(unsigned long x, unsigned char c) { return x ^ (unsigned long)c; }
static unsigned long band(unsigned long x, unsigned char c) { return (unsigned long)c & x; }
static unsigned long bor(unsigned long x, unsigned char c) { return x | (unsigned long)c; }

static unsigned long live(unsigned long x, unsigned int w, unsigned char c)
{
    unsigned long a = (unsigned long)w ^ x;
    unsigned long b = x & (unsigned long)c;
    keep(a);
    keep(b);
    return a ^ b ^ x;
}

static int run(void)
{
    int bad = 0;
    unsigned long x = 0x12345678UL;
    if (wxor(x, 0xABCDu) != 0x1234FDB5UL) bad++;
    if (wand(x, 0xABCDu) != 0x00000248UL) bad++;
    if (wor(x, 0xABCDu)  != 0x1234FFFDUL) bad++;
    if (bxor(x, 0x9C) != 0x123456E4UL) bad++;
    if (band(x, 0x9C) != 0x00000018UL) bad++;
    if (bor(x, 0x9C)  != 0x123456FCUL) bad++;
    if (wxor(0xFFFFFFFFUL, 0xFFFFu) != 0xFFFF0000UL) bad++;
    if (wand(0xFFFFFFFFUL, 0x8001u) != 0x00008001UL) bad++;
    /* a = w^x = 0x1234FDB5, b = x&c = 0x18; a^b^x = 0x1234FDB5^0x18^0x12345678 */
    if (live(x, 0xABCDu, 0x9C) != (0x1234FDB5UL ^ 0x18UL ^ 0x12345678UL)) bad++;
    if (sink != 0x18UL) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("zero-extended operand of a long and/or/xor");
    suite_add_test(check);
    return suite_run();
}
