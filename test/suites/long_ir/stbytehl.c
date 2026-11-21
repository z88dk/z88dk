/* A byte stored through a computed address (`buf[n++] = k`): the address stays
 * in HL into the store instead of being parked on the stack. The byte comes from
 * a slot, a call, a global, an expression and a loop counter, and the frame is
 * large enough that some slots are far from the frame base.
 */
#include "test.h"

static unsigned char g = 77;
static unsigned char seq;

static unsigned char next(void) { return ++seq; }

static unsigned put_param(char *buf, unsigned char max, unsigned char k)
{
    unsigned char n = 0;

    while (n < max) {
        buf[n++] = (char)k;
        buf[n] = 0;
        k++;
    }
    return n;
}

static void put_call(char *buf, unsigned char max)
{
    unsigned char n = 0, k;

    while (n < max) {
        k = next();
        buf[n++] = (char)k;
    }
}

static void put_global(char *buf, unsigned char n)
{
    buf[n] = g;
    buf[n + 1] = g + 1;
}

static void put_expr(char *buf, unsigned char a, unsigned char b)
{
    unsigned char i;

    for (i = 0; i < 4; i++)
        buf[i + 1] = (unsigned char)(a * i + b);
}

static unsigned put_big(char *buf, unsigned char k)
{
    char pad[200];
    unsigned char n = 0, j;

    for (j = 0; j < 8; j++)
        pad[j * 25] = (char)j;
    while (n < 3)
        buf[n++] = (char)(k + pad[n * 25]);
    return pad[75];
}

static void check(void)
{
    char b[16];
    unsigned i;

    for (i = 0; i < 16; i++) b[i] = 55;
    assertEqual(put_param(b, 4, 10), 4);
    assertEqual(b[0], 10);
    assertEqual(b[1], 11);
    assertEqual(b[3], 13);
    assertEqual(b[4], 0);
    assertEqual(b[5], 55);
    seq = 100;
    put_call(b, 3);
    assertEqual(b[0], 101);
    assertEqual(b[2], 103);
    put_global(b, 6);
    assertEqual(b[6], 77);
    assertEqual(b[7], 78);
    put_expr(b, 3, 9);
    assertEqual(b[1], 9);
    assertEqual(b[2], 12);
    assertEqual(b[4], 18);
    assertEqual(put_big(b, 40), 3);
    assertEqual(b[0], 40);
    assertEqual(b[1], 41);
    assertEqual(b[2], 42);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte store through a computed address");
    suite_add_test(check);
    return suite_run();
}
