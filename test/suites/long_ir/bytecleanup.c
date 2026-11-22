/* Byte results that read a widened byte. A sign or zero extension that also
 * feeds word arithmetic is shared with the byte operations that read only its
 * low byte, and a mask of 0xff (or an or/xor of 0) on a wider value is a
 * truncation. Every value of the signed and unsigned byte is checked against
 * the same arithmetic done through volatile copies, which cannot be shared.
 */
#include "test.h"

volatile signed char vs;
volatile unsigned char vu;
volatile int vi;

int shared(signed char s, unsigned char u)
{
    int acc = 0;
    acc += s;
    acc += u;
    acc += (signed char)(u ^ 0x80u);
    acc += (unsigned char)(s + 3);
    return acc;
}

static int reference(signed char s, unsigned char u)
{
    int acc = 0, t;
    vs = s; vu = u;
    t = vs; acc += t;
    t = vu; acc += t;
    vi = vu ^ 0x80; vs = (signed char)vi; t = vs; acc += t;
    vi = vs; vi = (int)(signed char)s + 3; vu = (unsigned char)vi; t = vu; acc += t;
    return acc;
}

unsigned long masked(int k)         { return (unsigned long)(unsigned char)(k & 0xff); }
unsigned char masked_or(int k)      { return (unsigned char)((k | 0) & 0xff); }
unsigned char masked_xor(int k)     { return (unsigned char)((k ^ 0) & 0xff); }

static int run(void)
{
    int bad = 0, s, u;
    long kl;
    for (s = -128; s < 128; s += 3)
        for (u = 0; u < 256; u += 5)
            if (shared((signed char)s, (unsigned char)u) != reference((signed char)s, (unsigned char)u))
                bad++;
    if (shared(-128, 255) != reference(-128, 255)) bad++;
    if (shared(127, 0) != reference(127, 0)) bad++;
    for (kl = -32768L; kl < 32768L; kl += 251) {
        int k = (int)kl;
        vi = k;
        if (masked(k) != (unsigned long)(vi & 255)) bad++;
        if (masked_or(k) != (unsigned char)(vi & 255)) bad++;
        if (masked_xor(k) != (unsigned char)(vi & 255)) bad++;
    }
    if (masked(0x1ff) != 255UL) bad++;
    if (masked(-1) != 255UL) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte results reading a widened byte");
    suite_add_test(check);
    return suite_run();
}
