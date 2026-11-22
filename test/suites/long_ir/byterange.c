/* A byte value shifted right stays a byte, so a following / or % by a
 * constant works on the byte; a value that is not provably a byte, or not
 * provably non-negative, must keep its full width and sign.
 */
#include "test.h"

typedef unsigned char u8;

/* Reference remainder and quotient by repeated subtraction, so the expected
   values never depend on the / and % lowering under test. */
static int ref_mod(int a, int m)
{
    int neg = a < 0;
    if (neg) a = -a;
    while (a >= m) a -= m;
    return neg ? -a : a;
}

static int ref_div(int a, int m)
{
    int neg = a < 0, q = 0;
    if (neg) a = -a;
    while (a >= m) { a -= m; ++q; }
    return neg ? -q : q;
}

static unsigned ref_umod(unsigned a, unsigned m)
{
    while (a >= m) a -= m;
    return a;
}

volatile u8 fb;
volatile unsigned fw;
volatile signed char fs;
volatile int fi;
u8 sink;

static u8 mod3(void) { return (u8)((fb >> 6) % 3); }
static u8 mod4(void) { return (u8)((fb >> 6) % 4); }
static u8 div5(void) { return (u8)((fb >> 3) / 5); }
static u8 mod4_7(void) { return (u8)((fb >> 7) % 4); }
static u8 mod8_6(void) { return (u8)((fb >> 6) % 8); }
static u8 mod2_7(void) { return (u8)((fb >> 7) % 2); }
static u8 mod4_1(void) { return (u8)((fb >> 1) % 4); }
static u8 mod4_5(void) { return (u8)((fb >> 5) % 4); }
static u8 div4(void) { return (u8)((fb >> 2) / 4); }

static unsigned wide_mod(void) { return (fw >> 6) % 3; }
static int signed_mod(void) { return (fs >> 6) % 3; }
static int signed_mod4(void) { return (fi >> 6) % 4; }

static u8 shr3(void) { return (u8)(fb >> 3); }
static u8 shr4(void) { return (u8)(fb >> 4); }
static u8 shr5(void) { return (u8)(fb >> 5); }
static u8 shr6(void) { return (u8)(fb >> 6); }
static u8 shr7(void) { return (u8)(fb >> 7); }

/* The remainder is returned as a byte straight from the helper, and, in
   the second, also kept in a store. */
static u8 ret_helper(unsigned a, unsigned b) { return a % b; }
static u8 ret_stored(unsigned a, unsigned b)
{
    u8 r = a / b;
    sink = r;
    return r;
}

u8 ga, gb;

/* A global byte read once and widened is re-read at the widen. */
static u8 clamp(void)
{
    if (ga > 96 - gb) ga = (u8)(96 - gb);
    return ga;
}

/* ...but not when the global is written in between. */
static int stale(void)
{
    u8 t = ga;
    ga = 7;
    return t;
}

/* A constant chosen by a ternary and passed on is loaded straight into HL. */
static int seen;
static void take(u8 x) { seen = x; }
static void tern_arg(void) { take(fb ? '>' : ' '); }

static void check_tern(void)
{
    fb = 1;  tern_arg(); assertEqual(seen, '>');
    fb = 0;  tern_arg(); assertEqual(seen, ' ');
    fb = 200; tern_arg(); assertEqual(seen, '>');
}

/* v = c ? K1 : K2 in several condition shapes. */
volatile unsigned gw;
volatile int gi;
static int dia_byte(void) { return fb ? 1000 : 2000; }
static int dia_cmp(void) { return fb > 100 ? -5 : 300; }
static int dia_eq(void) { return fb == 7 ? 11 : 22; }
static int dia_word(void) { return gw ? 70 : 80; }
static int dia_swap(void) { return !fb ? 3 : 4; }
static const char *dia_str(void) { return fb ? "yes" : "no"; }
static int dia_nest(void) { return fb ? (gi ? 1 : 2) : (gi ? 3 : 4); }
static int dia_use(void)
{
    int r = fb ? 5 : 6;
    return r + (fb ? 100 : 200);
}
static int dia_loop(void)
{
    int i, acc = 0;
    for (i = 0; i < 4; ++i)
        acc += (i & 1) ? 10 : 1;
    return acc;
}

static void check_diamond(void)
{
    int bad = 0, i;
    for (i = 0; i < 256; i += 3) {
        fb = (u8)i; gw = (unsigned)i * 257u; gi = i & 1;
        if (dia_byte() != (i ? 1000 : 2000)) ++bad;
        if (dia_cmp() != (i > 100 ? -5 : 300)) ++bad;
        if (dia_eq() != (i == 7 ? 11 : 22)) ++bad;
        if (dia_word() != (gw ? 70 : 80)) ++bad;
        if (dia_swap() != (i ? 4 : 3)) ++bad;
        if (dia_str()[0] != (i ? 'y' : 'n')) ++bad;
        if (dia_nest() != (i ? (gi ? 1 : 2) : (gi ? 3 : 4))) ++bad;
        if (dia_use() != (i ? 5 + 100 : 6 + 200)) ++bad;
        if (dia_loop() != 22) ++bad;
    }
    fb = 0; gw = 0; gi = 0;
    assertEqual(bad, 0);
}

/* Signed word compares of small-range operands skip the overflow repair. */
volatile u8 fc;
static int c_gt(void) { return fb > 96 - fc; }
static int c_lt(void) { return fb < 96 - fc; }
static int c_ge(void) { return fb >= 96 - fc; }
static int c_le(void) { return fb <= 96 - fc; }
static int c_rev(void) { return 96 - fc < fb; }
static int c_sub(void) { return (int)fc - 50 < (int)fb - 100; }
static int c_add(void) { return (int)fb + 16000 > 16100 - (int)fc; }

/* The difference overflows here, so the repair must stay. */
static int c_big(void) { return (int)fb + 30000 > -30000 - (int)fc; }
static int c_big2(void) { return -30000 - (int)fc < (int)fb + 30000; }

static void check_cmp(void)
{
    int bad = 0;
    unsigned a, b;
    for (a = 0; a < 256; a += 5)
        for (b = 0; b < 256; b += 3) {
            long d = (long)a - (long)(96 - (int)b);
            long e = ((long)b - 50) - ((long)a - 100);
            long g = ((long)a + 16000) - (16100 - (long)b);
            fb = (u8)a; fc = (u8)b;
            if ((c_gt() != 0) != (d > 0)) ++bad;
            if ((c_lt() != 0) != (d < 0)) ++bad;
            if ((c_ge() != 0) != (d >= 0)) ++bad;
            if ((c_le() != 0) != (d <= 0)) ++bad;
            if ((c_rev() != 0) != (d > 0)) ++bad;
            if ((c_sub() != 0) != (e < 0)) ++bad;
            if ((c_add() != 0) != (g > 0)) ++bad;
            if (!c_big() || !c_big2()) ++bad;
        }
    assertEqual(bad, 0);
}

static void check_remat(void)
{
    unsigned a, b;
    int bad = 0;
    for (a = 0; a < 256; a += 5)
        for (b = 0; b < 256; b += 3) {
            int rhs = 96 - (int)b;
            int want = (rhs < (int)a) ? (u8)rhs : (u8)a;
            ga = (u8)a; gb = (u8)b;
            if (clamp() != (u8)want) ++bad;
            ga = (u8)a;
            if (stale() != (int)a || ga != 7) ++bad;
        }
    assertEqual(bad, 0);
}

static void check(void)
{
    unsigned i;
    int bad = 0;
    for (i = 0; i < 256; ++i) {
        fb = (u8)i;
        if (mod3() != (u8)ref_mod((int)(i >> 6), 3)) ++bad;
        if (mod4() != (u8)ref_mod((int)(i >> 6), 4)) ++bad;
        if (div5() != (u8)ref_div((int)(i >> 3), 5)) ++bad;
        if (div4() != (u8)ref_div((int)(i >> 2), 4)) ++bad;
        if (mod4_7() != (u8)ref_mod((int)(i >> 7), 4)) ++bad;
        if (mod8_6() != (u8)ref_mod((int)(i >> 6), 8)) ++bad;
        if (mod2_7() != (u8)ref_mod((int)(i >> 7), 2)) ++bad;
        if (mod4_1() != (u8)ref_mod((int)(i >> 1), 4)) ++bad;
        if (mod4_5() != (u8)ref_mod((int)(i >> 5), 4)) ++bad;
        if (shr3() != (u8)(i >> 3)) ++bad;
        if (shr4() != (u8)(i >> 4)) ++bad;
        if (shr5() != (u8)(i >> 5)) ++bad;
        if (shr6() != (u8)(i >> 6)) ++bad;
        if (shr7() != (u8)(i >> 7)) ++bad;
    }
    assertEqual(bad, 0);
}

static void check_wide(void)
{
    unsigned v;
    int bad = 0;
    for (v = 0; v < 65535u - 997u; v += 997u) {
        fw = v;
        if (wide_mod() != ref_umod(v >> 6, 3)) ++bad;
    }
    assertEqual(bad, 0);
}

static void check_signed(void)
{
    int i, bad = 0;
    for (i = -128; i < 128; ++i) {
        fs = (signed char)i;
        if (signed_mod() != ref_mod(i >> 6, 3)) ++bad;
    }
    for (i = -300; i < 300; i += 7) {
        fi = i;
        if (signed_mod4() != ref_mod(i >> 6, 4)) ++bad;
    }
    assertEqual(bad, 0);
}

static void check_ret(void)
{
    unsigned a, b;
    int bad = 0;
    for (a = 0; a < 600; a += 7)
        for (b = 1; b < 40; b += 3) {
            if (ret_helper(a, b) != (u8)ref_umod(a, b)) ++bad;
            if (ret_stored(a, b) != (u8)ref_div(a, b) || sink != (u8)ref_div(a, b)) ++bad;
        }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte range / and % and shifts");
    suite_add_test(check);
    suite_add_test(check_wide);
    suite_add_test(check_signed);
    suite_add_test(check_ret);
    suite_add_test(check_remat);
    suite_add_test(check_cmp);
    suite_add_test(check_diamond);
    suite_add_test(check_tern);
    return suite_run();
}
