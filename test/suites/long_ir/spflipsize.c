/* Under --opt-code-size (by size) or, on a Z80 without it (by estimated T-states), an
 * IX-frame function may be emitted in its sp form when that is better. The sp form
 * must hand IX back as it found it: callers in an IX frame read their locals through
 * it after every call. Each helper here is a small multi-exit function with a byte
 * local, so it is a flip candidate, and some make calls that use IX in sp mode (far
 * access, fnptr dispatch, float). Each driver keeps locals in its own frame across
 * the call.
 */
#include "test.h"

typedef int (*ifn)(int);

static int twice(int x) { return x * 2; }

/* Multi-exit, byte local, no calls. */
static int classify(int x)
{
    unsigned char c = (unsigned char)(x & 7);

    if (c == 1) return 10;
    if (c == 2) return 20;
    if (c == 3) return 30;
    return c + 1;
}

/* Same shape with a call in the middle. */
static int classify_call(int x)
{
    unsigned char c = (unsigned char)twice(x & 3);

    if (c == 2) return 11;
    if (c == 4) return 22;
    if (c == 6) return 33;
    return c + 100;
}

/* Indirect call. */
static int via_ptr(ifn f, int x)
{
    unsigned char c = (unsigned char)f(x);

    if (c == 2) return 1;
    if (c == 4) return 2;
    if (c == 6) return 3;
    return c;
}

/* Far access. */
static int far_buf[4] = { 5, 6, 7, 8 };

static int far_pick(int i)
{
    int * __far fp = (int * __far)far_buf;
    unsigned char c = (unsigned char)i;

    if (c == 0) return fp[0];
    if (c == 1) return fp[1];
    if (c == 2) return fp[2];
    return fp[3];
}

/* Float helpers. */
static double fl_pick(double x, double y)
{
    unsigned char c = (unsigned char)x;

    if (c == 1) return y;
    if (c == 2) return x * y;
    if (c == 3) return x - y;
    return x + y;
}

/* Fastcall argument. */
static int fc(int x) __z88dk_fastcall
{
    unsigned char c = (unsigned char)x;

    if (c == 1) return 7;
    if (c == 2) return 8;
    if (c == 3) return 9;
    return c;
}

/* A byte local read back several times across exits, with calls before it. */
static int sink;
static void note(int v) { sink += v; }
static int conin(void) { return sink + 65; }

static unsigned char key(void)
{
    unsigned char k;

    note(1);
    k = (unsigned char)conin();
    switch (k) {
    case 19: return 8;
    case 4:  return 9;
    case 5:  return 11;
    case 24: return 10;
    case 127: return 8;
    }
    if (k >= 'A' && k <= 'Z' && k != 'O' && k != 'P' && k != 'Q' && k != 'A')
        k = (unsigned char)(k + ('a' - 'A'));
    return k;
}

/* Drivers: locals in the caller's frame must survive the call. */
static int drv_plain(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r = classify(2) + classify(9) + classify(4);

    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_call(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r = classify_call(1) + classify_call(2) + classify_call(0);

    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_ptr(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r = via_ptr(twice, 1) + via_ptr(twice, 2) + via_ptr(twice, 5);

    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_far(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r = far_pick(0) + far_pick(2) + far_pick(7);

    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_fl(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    double d = fl_pick(2.0, 3.0) + fl_pick(3.0, 1.0) + fl_pick(5.0, 1.0);

    return (int)d + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_fc(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r = fc(1) + fc(3) + fc(10);

    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static int drv_key(void)
{
    int a = 1234, b = 4321;
    unsigned char k = 9;
    int r;

    sink = 0;
    r = key();
    sink = 3;
    r += key();
    return r + (a - 1234) + (b - 4321) + (k - 9);
}

static void check(void)
{
    assertEqual(drv_plain(), 20 + 10 + 5);
    assertEqual(drv_call(), 11 + 22 + 100);
    assertEqual(drv_ptr(), 1 + 2 + 10);
    assertEqual(drv_far(), 5 + 7 + 8);
    assertEqual(drv_fl(), 6 + 2 + 6);
    assertEqual(drv_fc(), 7 + 9 + 10);
    assertEqual(drv_key(), 98 + 101);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("size-chosen sp form keeps IX");
    suite_add_test(check);
    return suite_run();
}
