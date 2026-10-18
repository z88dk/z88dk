/* A ternary arm narrower than the result is widened by its own signedness:
 * a signed char arm was zero-extended by a plain move.
 */
#include <stdint.h>
#include "test.h"

volatile uint8_t sel;
volatile int8_t sc = -5;
volatile uint8_t uc = 200;
volatile int16_t big = 100;
volatile uint8_t byte = 7;

static int16_t add_ternary(uint8_t *p, int8_t dir)
{
    return (int16_t)*p + (sel == 0 ? dir : dir * 10);
}

static int16_t arms(void)
{
    return (sel ? big : sc);
}

static int32_t arms_long(void)
{
    return (sel ? 100000L : (int32_t)sc);
}

static int16_t arms_u(void)
{
    return (sel ? big : uc);
}

static void check(void)
{
    uint8_t b = 7;

    sel = 0;
    assertEqual(add_ternary(&b, -3), 4);
    assertEqual(add_ternary(&b, 3), 10);
    sel = 1;
    assertEqual(add_ternary(&b, -3), -23);
    sel = 0;
    assertEqual(arms(), -5);
    assertEqual(arms_long() == -5L, 1);
    assertEqual(arms_u(), 200);
    sel = 1;
    assertEqual(arms(), 100);
    assertEqual(arms_long() == 100000L, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("ternary arm widening");
    suite_add_test(check);
    return suite_run();
}
