/* [ivsr-ez80-byte] Two arrays indexed by a byte-bounded int counter, with a
 * call in the loop. On ez80 the walking pointers are kept rather than
 * suppressed in favour of the counter. Both forms must give the same sums.
 * ez80 sp and fp, the opt-out, and z80 (where suppression still applies). */
#include "test.h"

#define N 64

static unsigned int sig[N];
static unsigned int coef[N];

static unsigned int mul8(unsigned int a, unsigned int b)
{
    return (unsigned int)(((unsigned long)a * b) >> 8);
}

static unsigned int dot(void)
{
    unsigned int acc = 0;
    int i;
    for (i = 0; i < N; i++)
        acc = (unsigned int)(acc + mul8(sig[i], coef[i]));
    return acc;
}

static unsigned int dot_ref(void)
{
    unsigned int acc = 0;
    unsigned int k;
    for (k = 0; k < N; k++) {
        unsigned long p = (unsigned long)sig[k] * coef[k];
        acc = (unsigned int)(acc + (unsigned int)(p >> 8));
    }
    return acc;
}

static void test_ivsrbyte(void)
{
    unsigned int seed = 0x1234u;
    int i;
    for (i = 0; i < N; i++) {
        seed = (unsigned int)(seed * 25173u + 13849u);
        sig[i] = seed;
        coef[i] = (unsigned int)(seed >> 3) ^ (unsigned int)i;
    }
    assertEqual(dot(), dot_ref());
    sig[0] = 0x100u; coef[0] = 0x100u;
    for (i = 1; i < N; i++) { sig[i] = 0; coef[i] = 0; }
    assertEqual(dot(), 0x100u);
    sig[N - 1] = 0x200u; coef[N - 1] = 0x300u;
    assertEqual(dot(), 0x100u + 0x600u);
}

int main(int argc, char *argv[])
{
    suite_setup("ivsrbyte");
    suite_add_test(test_ivsrbyte);
    return suite_run();
}
