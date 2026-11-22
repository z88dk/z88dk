/* Bytes and words held in variables, joined into a word or a long. References
 * multiply by volatile constants, so they never take the shift-and-or shape.
 * The last functions redefine a lane's source between its read and the join,
 * or use one byte twice: those must keep their meaning.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

volatile u32 k24 = 16777216UL, k16 = 65536UL, k8 = 256UL, k1 = 1UL;
volatile u16 j8 = 256, j1 = 1;
u8 gb;
u16 gw;
u8 arr[8] = { 0x11, 0x82, 0x33, 0xf4, 0x55, 0x06, 0x77, 0xe8 };

static u32 R(u8 a, u8 b, u8 c, u8 d) { return a*k24 + b*k16 + c*k8 + d*k1; }

/* two bytes -> word */
static u16 w_or(u8 x, u8 y)   { return ((u16)x << 8) | y; }
static u16 w_or2(u8 x, u8 y)  { return y | ((u16)x << 8); }
static u16 w_calc(u8 x, u8 y) { return ((u16)(x + 1) << 8) | (u8)(y ^ 0x5a); }
static u16 w_glob(void)       { return ((u16)gb << 8) | arr[3]; }
static u16 w_same(u8 x)       { return ((u16)x << 8) | x; }
/* the shift is done in int: a byte moved to the high half of a word */
static u16 w_int(u8 x, u8 y)  { return (u16)(((x) << 8) | (y)); }
static u16 w_int2(u8 x, u8 y) { return (u16)((y) | ((x) << 8)); }
static u16 w_int3(u8 x, u8 y) { return (u16)(((u8)(x + 1) << 8) | (u8)(y ^ 0x21)); }
/* four bytes -> long, every lane order */
static u32 l_abcd(u8 a, u8 b, u8 c, u8 d) { return ((u32)a<<24)|((u32)b<<16)|((u32)c<<8)|d; }
static u32 l_dcba(u8 a, u8 b, u8 c, u8 d) { return d|((u32)c<<8)|((u32)b<<16)|((u32)a<<24); }
static u32 l_bdac(u8 a, u8 b, u8 c, u8 d) { return ((u32)b<<24)|((u32)d<<16)|((u32)a<<8)|c; }
static u32 l_calc(u8 a, u8 b)             { return ((u32)(u8)(a+1)<<24)|((u32)(u8)(b^0xff)<<16)|((u32)(u8)(a|b)<<8)|(u8)(a-b); }
static u32 l_same(u8 a)                   { return ((u32)a<<24)|((u32)a<<16)|((u32)a<<8)|a; }
static u32 l_arr(void)                    { return ((u32)arr[0]<<24)|((u32)gb<<16)|((u32)arr[5]<<8)|arr[7]; }
/* three bytes -> long (the top byte is zero) */
static u32 l_three(u8 a, u8 b, u8 c)      { return ((u32)a<<16)|((u32)b<<8)|c; }
static u32 l_three2(u8 a, u8 b, u8 c)     { return c|((u32)b<<8)|((u32)a<<16); }
static u32 l_three3(u8 a, u8 b)           { return ((u32)(u8)(a+b)<<16)|((u32)a<<8)|(u8)(b^0x33); }
/* two words -> long */
static u32 j_hl(u16 hi, u16 lo)   { return ((u32)hi << 16) | lo; }
static u32 j_lh(u16 hi, u16 lo)   { return lo | ((u32)hi << 16); }
static u32 j_calc(u16 x)          { return ((u32)(x + 3) << 16) | (u16)(x ^ 0x0ff0); }
static u32 j_glob(void)           { return ((u32)gw << 16) | (u16)(gw + 1); }
/* the result feeds more work */
static u32 l_use(u8 a, u8 b, u8 c, u8 d)  { u32 r = l_abcd(a, b, c, d); return r + 1; }
static u16 w_use(u8 x, u8 y)              { return (u16)(w_or(x, y) + 5); }
/* a lane's source changes between its read and the join: must keep both values */
static u32 l_redef(u8 a, u8 b)
{
    u32 r = (u32)a << 24;
    a = (u8)(a + 1);
    r |= (u32)a << 16;
    r |= (u32)b << 8;
    return r | (u8)(a + b);
}
static u16 w_redef(u8 x)
{
    u16 r = (u16)x << 8;
    x = (u8)(x + 7);
    return r | x;
}

static void check(void)
{
    int bad = 0;
    unsigned x, y, i;
    for (i = 0; i < 8; ++i) arr[i] = (u8)(arr[i] + i * 3);
    for (x = 0; x < 256; x += 13)
        for (y = 0; y < 256; y += 19) {
            u8 a = (u8)x, b = (u8)y, c = (u8)(x + 91), d = (u8)(y + 37);
            gb = (u8)(x ^ y);
            if (w_or(a, b)   != (u16)(a*j8 + b))  ++bad;
            if (w_or2(a, b)  != (u16)(a*j8 + b))  ++bad;
            if (w_calc(a, b) != (u16)((u8)(a+1)*j8 + (u8)(b^0x5a))) ++bad;
            if (w_glob()     != (u16)(gb*j8 + arr[3])) ++bad;
            if (w_int(a, b)  != (u16)(a*j8 + b))  ++bad;
            if (w_int2(a, b) != (u16)(a*j8 + b))  ++bad;
            if (w_int3(a, b) != (u16)((u8)(a+1)*j8 + (u8)(b^0x21))) ++bad;
            if (w_same(a)    != (u16)(a*j8 + a))  ++bad;
            if (w_use(a, b)  != (u16)(a*j8 + b + 5)) ++bad;
            if (l_abcd(a,b,c,d) != R(a,b,c,d)) ++bad;
            if (l_dcba(a,b,c,d) != R(a,b,c,d)) ++bad;
            if (l_bdac(a,b,c,d) != R(b,d,a,c)) ++bad;
            if (l_calc(a, b)    != R((u8)(a+1), (u8)(b^0xff), (u8)(a|b), (u8)(a-b))) ++bad;
            if (l_same(a)       != R(a,a,a,a)) ++bad;
            if (l_arr()         != R(arr[0], gb, arr[5], arr[7])) ++bad;
            if (l_three(a,b,c)  != R(0,a,b,c)) ++bad;
            if (l_three2(a,b,c) != R(0,a,b,c)) ++bad;
            if (l_three3(a,b)   != R(0,(u8)(a+b), a, (u8)(b^0x33))) ++bad;
            if (l_use(a,b,c,d)  != R(a,b,c,d) + 1) ++bad;
            if (l_redef(a, b)   != R(a, (u8)(a+1), b, (u8)((u8)(a+1)+b))) ++bad;
            if (w_redef(a)      != (u16)(a*j8 + (u8)(a+7))) ++bad;
            {
                u16 hi = (u16)(x * 257u + 3), lo = (u16)(y * 251u + 9);
                gw = hi;
                if (j_hl(hi, lo)  != (u32)hi*k16 + lo) ++bad;
                if (j_lh(hi, lo)  != (u32)hi*k16 + lo) ++bad;
                if (j_calc(hi)    != (u32)(u16)(hi+3)*k16 + (u16)(hi ^ 0x0ff0)) ++bad;
                if (j_glob()      != (u32)hi*k16 + (u16)(hi+1)) ++bad;
            }
        }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bytes and words joined in registers");
    suite_add_test(check);
    return suite_run();
}
