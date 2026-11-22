/* A long multiply by a constant is expanded inline only for 2^a, 2^a+1 and
 * 2^a-1; every other constant calls l_long_mult_u. Both sides must give the
 * same answer as multiplying by the same value held in a variable.
 */
#include "test.h"

static volatile unsigned long vk;

#define CHECK(K)                                                    \
    do {                                                            \
        vk = (K);                                                   \
        for (i = 0; i < 6; i++) {                                   \
            unsigned long x = xs[i];                                \
            if (x * (K) != x * vk) bad++;                           \
        }                                                           \
    } while (0)

static unsigned long xs[6] = { 0UL, 1UL, 12345UL, 65535UL, 0x12345678UL, 0xFFFFFFFFUL };

static int run(void)
{
    int bad = 0;
    unsigned i;
    CHECK(2UL); CHECK(3UL); CHECK(4UL); CHECK(5UL); CHECK(6UL); CHECK(7UL);
    CHECK(8UL); CHECK(9UL); CHECK(10UL); CHECK(12UL); CHECK(15UL);
    CHECK(16UL); CHECK(17UL); CHECK(20UL); CHECK(24UL); CHECK(25UL);
    CHECK(31UL); CHECK(40UL); CHECK(63UL); CHECK(100UL); CHECK(127UL);
    CHECK(255UL); CHECK(257UL); CHECK(1000UL); CHECK(65537UL); CHECK(100000UL);
    return bad;
}

/* (x << n) +/- x written out, in both operand orders, with the shifted value
 * used once (saved-operand form) and twice (it must not pair). */
static volatile unsigned long vm;

static int shapes(void)
{
    int bad = 0;
    unsigned i;
    for (i = 0; i < 6; i++) {
        unsigned long x = xs[i];
        unsigned long t;
        vm = 9;   if (((x << 3) + x) != x * vm) bad++;
        vm = 33;  if ((x + (x << 5)) != x * vm) bad++;
        vm = 15;  if (((x << 4) - x) != x * vm) bad++;
        vm = 513; if (((x << 9) + x) != x * vm) bad++;
        vm = 65535UL; if (((x << 16) - x) != x * vm) bad++;
        vm = 3;   if (((x << 1) + x) != x * vm) bad++;
        t = x << 2;
        vm = 9;   if ((t + x + t) != x * vm) bad++;     /* t used twice */
        vm = 3;   if (((x << 1) + x + (x << 1)) != x * vm + (x << 1)) bad++;
        vm = 7;   if (((x << 3) - x) != x * vm) bad++;
    }
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
    assertEqual(shapes(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long constant multiply");
    suite_add_test(check);
    return suite_run();
}
