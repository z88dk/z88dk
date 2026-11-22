/* Bytes read once from their frame slots (parameters and spilled locals) and
 * widened or stored through a pointer. Each function has a twin that reads the
 * bytes through volatile copies, so the expected values do not depend on the
 * code generator under test.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;

u8 buf[16];
u8 *volatile ptr = buf;
u8 vv;

static u16 w1(u8 a, u8 b, u8 c)     { return (u16)(a + 1) * 3 + b + c; }
static u16 w1v(u8 a, u8 b, u8 c)    { volatile u8 x = a, y = b, z = c; return (u16)(x + 1) * 3 + y + z; }
static u16 wide(u8 a, u8 b)         { return (u16)a * 300 + b; }
static u16 widev(u8 a, u8 b)        { volatile u8 x = a, y = b; return (u16)x * 300 + y; }
static void st1(u8 *p, u8 v, u8 w)  { *p = v; p[1] = w; ptr[2] = (u8)(v + w); }
static void st1v(u8 *p, u8 v, u8 w) { volatile u8 x = v, y = w; *p = x; p[1] = y; ptr[2] = (u8)(x + y); }
static u16 mix(u8 a, u8 b, u8 c, u8 d)
{
    u16 t = a;
    t = t * 7 + b;
    *ptr = c;
    t += d;
    return t + *ptr;
}
static u16 mixv(u8 a, u8 b, u8 c, u8 d)
{
    volatile u8 x = a, y = b, z = c, q = d;
    u16 t = x;
    t = t * 7 + y;
    *ptr = z;
    t += q;
    return t + *ptr;
}
/* the byte is read again after the widening: it must still be right */
static u16 twice(u8 a, u8 b)
{
    u16 t = a;
    t += b * 5;
    t += a;
    return t;
}
static u16 twicev(u8 a, u8 b)
{
    volatile u8 x = a, y = b;
    u16 t = x;
    t += y * 5;
    t += x;
    return t;
}
static u8 retb(u8 a, u8 b) { return (u8)(a ^ b); }
static u8 retbv(u8 a, u8 b){ volatile u8 x = a, y = b; return (u8)(x ^ y); }

static void check(void)
{
    int bad = 0;
    unsigned x, y;
    for (x = 0; x < 256; x += 17)
        for (y = 0; y < 256; y += 23) {
            u8 a = (u8)x, b = (u8)y, c = (u8)(x + 77), d = (u8)(y + 5);
            u8 s1, s2, s3, r1, r2, r3;
            if (w1(a, b, c) != w1v(a, b, c)) ++bad;
            if (wide(a, b) != widev(a, b)) ++bad;
            st1(&buf[4], a, b);  s1 = buf[4]; s2 = buf[5]; s3 = buf[2];
            st1v(&buf[8], a, b); r1 = buf[8]; r2 = buf[9]; r3 = buf[2];
            if (s1 != r1 || s2 != r2 || s3 != r3) ++bad;
            if (mix(a, b, c, d) != mixv(a, b, c, d)) ++bad;
            if (twice(a, b) != twicev(a, b)) ++bad;
            if (retb(a, b) != retbv(a, b)) ++bad;
        }
    /* fixed values, in case both twins were wrong in the same way */
    if (w1(10, 20, 30) != 83) ++bad;
    if (w1(255, 1, 2) != 771) ++bad;
    if (wide(3, 4) != 904) ++bad;
    if (twice(2, 3) != 19) ++bad;
    if (retb(0x0f, 0x3c) != 0x33) ++bad;
    st1(&buf[12], 9, 4);
    if (buf[12] != 9 || buf[13] != 4 || buf[2] != 13) ++bad;
    if (mix(1, 2, 3, 4) != 7 + 2 + 4 + 3) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bytes read once from the frame");
    suite_add_test(check);
    return suite_run();
}
