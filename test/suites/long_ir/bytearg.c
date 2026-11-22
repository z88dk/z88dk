/* Byte arguments pushed for a stack-passed call: a char parameter ignores the
 * high byte of its slot, an int, unprototyped or variadic one reads it, so the
 * byte must reach those zero- or sign-extended.
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "test.h"

struct run { uint8_t row, col, len, attr; };

static uint8_t sink[4];

static void put4(uint8_t a, uint8_t b, uint8_t c, uint8_t d)
{
    sink[0] = a; sink[1] = b; sink[2] = c; sink[3] = d;
}

static int wide(int a, int b) { return a * 1000 + b; }

static void walk(const struct run *r, uint8_t n, uint8_t row, uint8_t base)
{
    for (; n; --n, ++r)
        if (r->row == row)
            put4((uint8_t)(r->col + base), row, r->len, r->attr);
}

static int run_char(void)
{
    static const struct run t[] = { {1, 2, 3, 4}, {7, 0xf0, 0xe1, 0xd2} };
    walk(t, 2, 7, 0x20);
    return sink[0] == 0x10 && sink[1] == 7 && sink[2] == 0xe1 && sink[3] == 0xd2;
}

static unsigned int mixed(unsigned int a, uint8_t b, uint8_t c, unsigned int d)
{
    return (unsigned int)(a * 7u + b * 5u + c * 3u + d);
}

static int run_order(void)
{
    static const uint8_t t[] = { 9, 250, 3 };
    unsigned int x = 1000, y = 77;
    uint8_t k = 2;
    return mixed(x, t[k - 1], t[k], y) == 1000 * 7 + 250 * 5 + 3 * 3 + 77
        && mixed(y, 4, t[k - 2], x) == 77 * 7 + 4 * 5 + 9 * 3 + 1000;
}

static int run_int(void)
{
    static const uint8_t u[] = { 200, 250 };
    static const int8_t s[] = { -5, 100 };
    return wide(u[0], u[1]) == 200 * 1000 + 250
        && wide(s[0], s[1]) == -5 * 1000 + 100
        && wide(u[1], s[0]) == 250 * 1000 - 5;
}

static int run_variadic(void)
{
    static const uint8_t u[] = { 200, 3 };
    static const int8_t s[] = { -7, 1 };
    char buf[24];
    sprintf(buf, "%d %d %d %d", u[0], u[1], s[0], s[1]);
    return strcmp(buf, "200 3 -7 1") == 0;
}

static void check_char(void) { assertEqual(run_char(), 1); }
static void check_order(void) { assertEqual(run_order(), 1); }
static void check_int(void) { assertEqual(run_int(), 1); }
static void check_variadic(void) { assertEqual(run_variadic(), 1); }

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte args to stack slots");
    suite_add_test(check_char);
    suite_add_test(check_order);
    suite_add_test(check_int);
    suite_add_test(check_variadic);
    return suite_run();
}
