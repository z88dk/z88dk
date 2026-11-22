/* SIGNED RELATIONAL COMPARES OF TWO BYTE VARIABLES USE THE SIGNED VALUES.
 *
 *     signed char a, b;   a < b   a <= b   a > b   a >= b
 *
 * C promotes both operands to int, so -1 < 1 is true. A compare kept at byte
 * width must not zero-extend a negative operand (255 < 1 is false). The operands
 * come from parameters, globals, pointers and array elements, in value and
 * branch position, and mix signed with unsigned bytes. Expected values come
 * from hand-written constants and from the explicit-cast form, which widens
 * with sign extension.
 */
#include "test.h"

static signed char ga, gb;
static signed char sarr[4] = { -3, 3, -128, 127 };
static unsigned char uarr[4] = { 3, 200, 0, 255 };

static int lt(signed char a, signed char b) { return a < b; }
static int le(signed char a, signed char b) { return a <= b; }
static int gt(signed char a, signed char b) { return a > b; }
static int ge(signed char a, signed char b) { return a >= b; }
static int ref_lt(signed char a, signed char b) { return (int)a < (int)b; }
static int ref_le(signed char a, signed char b) { return (int)a <= (int)b; }
static int ref_gt(signed char a, signed char b) { return (int)a > (int)b; }
static int ref_ge(signed char a, signed char b) { return (int)a >= (int)b; }

static int blt(signed char a, signed char b) { if (a < b) return 1; return 0; }
static int bge(signed char a, signed char b) { if (a >= b) return 1; return 0; }
static int glt(void) { return ga < gb; }
static int gge(void) { if (ga >= gb) return 1; return 0; }
static int plt(signed char *p) { return p[0] < p[1]; }
static int pgt(signed char *p) { if (p[0] > p[1]) return 1; return 0; }

/* signed against unsigned byte: both promote to int */
static int su_lt(signed char a, unsigned char b) { return a < b; }
static int us_gt(unsigned char a, signed char b) { return a > b; }
static int uu_lt(unsigned char a, unsigned char b) { return a < b; }


/* the promoted-type rule beyond chars */
static int i_u8(int a, unsigned char b)            { return a < b; }
static int u8_i(unsigned char a, int b)            { return a > b; }
static int i_u16(int a, unsigned int b)            { return a < b; }
static int l_u16(long a, unsigned int b)           { return a < b; }
static int u16_l(unsigned int a, long b)           { return a > b; }
static int l_ul(long a, unsigned long b)           { return a < b; }
static int u16_u8(unsigned int a, unsigned char b) { return a < b; }
static int s16_s8(int a, signed char b)            { return a < b; }


/* provably non-negative operands compare the same signed or unsigned */
static unsigned char vw, ox, cx;
static int cx_ge_sum(void)  { return cx >= ox + vw; }
static int cx_lt_sum(void)  { return cx < ox + vw; }
static int and_gt(unsigned char a) { return (a & 0x7f) > 100; }
static int lit_ge(unsigned char c) { return c >= 'a'; }
static int lit_le(unsigned char c) { return c <= 'z'; }
/* the right side can be negative: this one must stay signed */
static int below_room(void)  { return ox > 120 - vw; }

static int smax(signed char *p, int n)
{
    signed char m = p[0];
    int i;
    for (i = 1; i < n; i++)
        if (m < p[i]) m = p[i];
    return m;
}

void test_scmp(void)
{
    int i, j;
    signed char vals[8] = { -128, -127, -2, -1, 0, 1, 126, 127 };

    assertEqual(lt(-1, 1), 1);   assertEqual(lt(1, -1), 0);
    assertEqual(le(-1, 1), 1);   assertEqual(le(-1, -1), 1);
    assertEqual(gt(-1, 1), 0);   assertEqual(gt(1, -1), 1);
    assertEqual(ge(-1, 1), 0);   assertEqual(ge(5, -5), 1);
    assertEqual(lt(-128, 127), 1);  assertEqual(gt(127, -128), 1);
    assertEqual(blt(-1, 1), 1);  assertEqual(bge(-1, 1), 0);
    assertEqual(bge(1, -1), 1);

    for (i = 0; i < 8; i++) {
        for (j = 0; j < 8; j++) {
            signed char a = vals[i], b = vals[j];
            assertEqual(lt(a, b), ref_lt(a, b));
            assertEqual(le(a, b), ref_le(a, b));
            assertEqual(gt(a, b), ref_gt(a, b));
            assertEqual(ge(a, b), ref_ge(a, b));
            assertEqual(blt(a, b), ref_lt(a, b));
            assertEqual(bge(a, b), ref_ge(a, b));
            ga = a; gb = b;
            assertEqual(glt(), ref_lt(a, b));
            assertEqual(gge(), ref_ge(a, b));
        }
    }

    assertEqual(plt(sarr), 1);        /* -3 < 3 */
    assertEqual(plt(sarr + 1), 0);    /* 3 < -128 */
    assertEqual(plt(sarr + 2), 1);    /* -128 < 127 */
    assertEqual(pgt(sarr), 0);
    assertEqual(pgt(sarr + 1), 1);

    assertEqual(su_lt(-1, 200), 1);   /* -1 < 200 */
    assertEqual(su_lt(100, 50), 0);
    assertEqual(us_gt(200, -1), 1);
    assertEqual(us_gt(0, -1), 1);
    assertEqual(us_gt(3, 3), 0);
    assertEqual(uu_lt(200, 255), 1);
    assertEqual(uu_lt(255, 200), 0);


    assertEqual(i_u8(-1, 5), 1);        /* int vs uchar: signed, -1 < 5 */
    assertEqual(i_u8(300, 5), 0);
    assertEqual(u8_i(5, -1), 1);        /* 5 > -1 */
    assertEqual(i_u16(-1, 5), 0);       /* int vs unsigned int: unsigned, 65535 < 5 */
    assertEqual(i_u16(3, 5), 1);
    assertEqual(l_u16(-1L, 5), 1);      /* long holds every unsigned int: signed */
    assertEqual(l_u16(70000L, 5), 0);
    assertEqual(u16_l(5, -1L), 1);      /* 5 > -1 */
    assertEqual(l_ul(-1L, 5UL), 0);     /* long vs unsigned long: unsigned */
    assertEqual(l_ul(3L, 5UL), 1);
    assertEqual(u16_u8(300, 200), 0);
    assertEqual(u16_u8(100, 200), 1);
    assertEqual(s16_s8(-300, -2), 1);
    assertEqual(s16_s8(5, -2), 0);

    cx = 200; ox = 100; vw = 100;  assertEqual(cx_ge_sum(), 1);   /* 200 >= 200 */
    cx = 199;                      assertEqual(cx_ge_sum(), 0);
    cx = 255; ox = 255; vw = 255;  assertEqual(cx_ge_sum(), 0);   /* sum 510 does not wrap */
    cx = 5;   ox = 0;   vw = 0;    assertEqual(cx_ge_sum(), 1);
    cx = 5;   ox = 3;   vw = 3;    assertEqual(cx_lt_sum(), 1);
    assertEqual(and_gt(0xff), 1);  assertEqual(and_gt(0x64), 0);  assertEqual(and_gt(0xe5), 1);
    assertEqual(lit_ge(0x61), 1);  assertEqual(lit_ge(0x60), 0);  assertEqual(lit_ge(0xf0), 1);
    assertEqual(lit_le(0x7a), 1);  assertEqual(lit_le(0x7b), 0);  assertEqual(lit_le(0xf0), 0);
    ox = 5;   vw = 100;            assertEqual(below_room(), 0);   /* 5 > 20 */
    ox = 50;  vw = 100;            assertEqual(below_room(), 1);   /* 50 > 20 */
    ox = 0;   vw = 200;            assertEqual(below_room(), 1);   /* 0 > -80: signed */
    ox = 255; vw = 255;            assertEqual(below_room(), 1);   /* 255 > -135 */

    assertEqual(smax(sarr, 4), 127);
    assertEqual(smax(sarr, 3), 3);
    assertEqual(smax(sarr, 1), -3);
    (void)uarr;
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("signed relational compares of two byte variables");
    suite_add_test(test_scmp);
    return suite_run();
}
