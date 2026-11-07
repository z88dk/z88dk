/* A reversed-loop counter that may live in BC: it survives calls, nested
 * loops and BC-hungry neighbours, and runs exactly N times.
 */
#include "test.h"

int gc;
unsigned char gb[8];
volatile unsigned char gv;

static void bump(void) { ++gc; }
static void bump_by(int n) { gc += n; }

static int calls4(void)
{
    unsigned char i;
    gc = 0;
    for (i = 0; i < 4; ++i)
        bump();
    return gc;
}

static int calls255(void)
{
    unsigned char i;
    gc = 0;
    for (i = 0; i < 255; ++i)
        bump();
    return gc;
}

static int calls256(void)
{
    int i;
    gc = 0;
    for (i = 0; i < 256; ++i)
        bump();
    return gc;
}

static int nested(void)
{
    unsigned char i, j;
    gc = 0;
    for (i = 0; i < 3; ++i)
        for (j = 0; j < 5; ++j)
            bump();
    return gc;
}

static int two_calls(void)
{
    unsigned char i;
    gc = 0;
    for (i = 0; i < 6; ++i) {
        bump();
        bump_by(10);
    }
    return gc;
}

static int with_ptr(unsigned char *p)
{
    unsigned char i;
    int s = 0;
    for (i = 0; i < 8; ++i) {
        s += *p++;
        bump();
    }
    return s + gc * 1000;
}

static int with_long(void)
{
    unsigned char i;
    long acc = 0;
    gc = 0;
    for (i = 0; i < 7; ++i) {
        acc += 100000L;
        bump();
    }
    return (int)(acc / 1000) + gc;
}

static int index_after(void)
{
    int i, n = 0;
    for (i = 0; i < 9; ++i)
        bump();
    n = i;
    return n;
}

static int far_body(void)
{
    unsigned char i;
    gv = 0;
    for (i = 0; i < 3; ++i) {
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
        gv++;
    }
    return gv;
}

static void check(void)
{
    int k;
    assertEqual(calls4(), 4);
    assertEqual(calls255(), 255);
    assertEqual(calls256(), 256);
    assertEqual(nested(), 15);
    assertEqual(two_calls(), 66);
    for (k = 0; k < 8; ++k) gb[k] = (unsigned char)(k + 1);
    gc = 0;
    assertEqual(with_ptr(gb), 36 + 8000);
    assertEqual(with_long(), 700 + 7);
    gc = 0;
    assertEqual(index_after(), 9);
    assertEqual(far_body(), 90);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("reversed-loop counter in BC");
    suite_add_test(check);
    return suite_run();
}
