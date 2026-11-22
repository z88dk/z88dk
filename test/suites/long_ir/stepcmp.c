/* x++ == K, x-- != K and friends: the old value is compared with K, so the
 * stepped value is compared with K + 1 (K - 1), in the width of x. The wrap at
 * the end of the range is the case that matters.
 */
#include "test.h"

int gw;
unsigned int gu;
unsigned char gb;
signed char gs;

static int inc_eq_w(int k)        { return gw++ == k; }
static int inc_ne_w(void)         { return gw++ != 7; }
static int dec_eq_w(void)         { return gw-- == 0; }
static int dec_eq_m1(void)        { return gw-- == -1; }
static int inc_eq_u(void)         { return gu++ == 65535u; }
static int inc_eq_b(void)         { return gb++ == 255; }
static int dec_eq_b(void)         { return gb-- == 0; }
static int inc_eq_s(void)         { return gs++ == 127; }
static int dec_eq_s(void)         { return gs-- == -128; }
static int local_inc(int x)       { int y = x; if (y++ == 9) return y; return -y; }
static int local_dec(int x)       { int y = x; if (y-- == 0) return y; return y + 100; }

static void check(void)
{
    gw = 6;  assertEqual(inc_ne_w(), 1); assertEqual(gw, 7);
    assertEqual(inc_ne_w(), 0); assertEqual(gw, 8);
    gw = 5;  assertEqual(inc_eq_w(5), 1); assertEqual(gw, 6);
    assertEqual(inc_eq_w(5), 0); assertEqual(gw, 7);
    gw = 0;  assertEqual(dec_eq_w(), 1); assertEqual(gw, -1);
    assertEqual(dec_eq_m1(), 1); assertEqual(gw, -2);
    assertEqual(dec_eq_w(), 0);
    gw = 32767; assertEqual(inc_eq_w(32767), 1); assertEqual(gw, -32768);
    gu = 65535u; assertEqual(inc_eq_u(), 1); assertEqual(gu, 0);
    assertEqual(inc_eq_u(), 0); assertEqual(gu, 1);
    gb = 255; assertEqual(inc_eq_b(), 1); assertEqual(gb, 0);
    assertEqual(inc_eq_b(), 0); assertEqual(gb, 1);
    gb = 0;   assertEqual(dec_eq_b(), 1); assertEqual(gb, 255);
    assertEqual(dec_eq_b(), 0); assertEqual(gb, 254);
    gs = 127; assertEqual(inc_eq_s(), 1); assertEqual(gs, -128);
    gs = -128; assertEqual(dec_eq_s(), 1); assertEqual(gs, 127);
    assertEqual(local_inc(9), 10);
    assertEqual(local_inc(8), -9);
    assertEqual(local_dec(0), -1);
    assertEqual(local_dec(5), 104);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("x++ == K compares the stepped value");
    suite_add_test(check);
    return suite_run();
}
