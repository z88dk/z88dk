/* A constant added to a word that lives in a register inside a loop: small,
 * large, negative, and edge constants, with the sum checked against adding the
 * same value held in a variable.
 */
#include "test.h"

static volatile unsigned int vk;
static const unsigned int base[] = { 0, 1, 255, 256, 1000, 32767, 32768, 65535, 40000, 12345 };
#define NB ((int)(sizeof base / sizeof base[0]))

#define ADDK(K)                                                       \
    do {                                                              \
        vk = (unsigned int)(K);                                       \
        for (i = 0; i < NB; i++) {                                    \
            unsigned int x = base[i];                                 \
            unsigned int y = x + (unsigned int)(K);                   \
            if (y != (unsigned int)(x + vk)) bad++;                   \
            acc = (unsigned int)(acc + (unsigned int)(K));            \
            accv = (unsigned int)(accv + vk);                         \
        }                                                             \
        if (acc != accv) bad++;                                       \
    } while (0)

static int run(void)
{
    int bad = 0, i;
    unsigned int acc = 0, accv = 0;
    ADDK(4); ADDK(5); ADDK(32); ADDK(100); ADDK(255); ADDK(256); ADDK(1000);
    ADDK(0x7fff); ADDK(0x8000); ADDK(0xffff); ADDK(-4); ADDK(-5); ADDK(-100);
    ADDK(-1000); ADDK(-32768);
    return bad;
}

static unsigned int total;
static void take(unsigned int a, unsigned int b, unsigned int c)
{
    total = (unsigned int)(total + a * 3u + b * 5u + c);
}

/* A loop counter in a register with `i + K` passed to a call. */
static unsigned int counter_args(void)
{
    int i;
    total = 0;
    for (i = 0; i < 300; i++)
        take((unsigned int)(i + 32), (unsigned int)(i + 27), (unsigned int)(i - 5));
    return total;
}

static unsigned int expected_args(void)
{
    unsigned int t = 0, i;
    for (i = 0; i < 300; i++)
        t = (unsigned int)(t + (i + 32u) * 3u + (i + 27u) * 5u + (i - 5u));
    return t;
}

static void check(void)
{
    assertEqual(run(), 0);
    assertEqual(counter_args(), expected_args());
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant added to a register word");
    suite_add_test(check);
    return suite_run();
}
