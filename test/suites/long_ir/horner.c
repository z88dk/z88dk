/* Accumulate-and-shift chains: r = (r << 8) | b, repeated. References multiply
 * by volatile constants, so they never take the shift-and-or shape. The chains
 * that read r in between, shift by other amounts or leave a lane out must keep
 * their meaning.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

volatile u32 k24 = 16777216UL, k16 = 65536UL, k8 = 256UL, k1 = 1UL;
volatile u32 sink;
u8 gb;

static u32 R(u8 a, u8 b, u8 c, u8 d) { return a*k24 + b*k16 + c*k8 + d*k1; }

static u32 h_args(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 8) | c;
    r = (r << 8) | d;
    return r;
}
static u32 h_swapped(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = a;
    r = b | (r << 8);
    r = c | (r << 8);
    r = d | (r << 8);
    return r;
}
static u32 h_calc(u8 a, u8 b)
{
    u32 r = (u8)(a + 1);
    r = (r << 8) | (u8)(b ^ 0x5a);
    r = (r << 8) | (u8)(a | b);
    r = (r << 8) | (u8)(a - b);
    return r;
}
static u32 h_glob(void)
{
    u32 r = gb;
    r = (r << 8) | (u8)(gb + 1);
    r = (r << 8) | (u8)(gb + 2);
    r = (r << 8) | (u8)(gb + 3);
    return r;
}
static u32 h_use(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = h_args(a, b, c, d);
    return r + 1;
}
/* the partial value is read between steps */
static u32 h_peek(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = a;
    r = (r << 8) | b;
    sink = r;
    r = (r << 8) | c;
    r = (r << 8) | d;
    return r;
}
/* the partial value is read by the next lane's own source */
static u32 h_self(u8 a, u8 b)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 8) | (u8)r;
    r = (r << 8) | (u8)(r >> 8);
    return r;
}
/* three lanes only, and a wider first step */
static u32 h_three(u8 a, u8 b, u8 c)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 8) | c;
    return r;
}
static u32 h_wide(u16 a, u8 b, u8 c)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 8) | c;
    return r;
}
static u32 h_shift16(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 16) | c;
    r = (r << 8) | d;
    return r;
}
/* the chain continues past four lanes */
static u32 h_five(u8 a, u8 b, u8 c, u8 d, u8 e)
{
    u32 r = a;
    r = (r << 8) | b;
    r = (r << 8) | c;
    r = (r << 8) | d;
    r = (r << 8) | e;
    return r;
}
/* two independent chains */
static u32 h_two(u8 a, u8 b, u8 c, u8 d)
{
    u32 r = a, s = c;
    r = (r << 8) | b;
    s = (s << 8) | d;
    r = (r << 8) | (u8)s;
    s = (s << 8) | (u8)r;
    r = (r << 8) | (u8)(s >> 8);
    return r ^ s;
}

static void check(void)
{
    int bad = 0;
    unsigned x, y;
    for (x = 0; x < 256; x += 13)
        for (y = 0; y < 256; y += 19) {
            u8 a = (u8)x, b = (u8)y, c = (u8)(x + 91), d = (u8)(y + 37);
            u8 e = (u8)(x ^ y);
            u32 want, r, s;
            gb = (u8)(x ^ y);
            if (h_args(a,b,c,d)    != R(a,b,c,d)) ++bad;
            if (h_swapped(a,b,c,d) != R(a,b,c,d)) ++bad;
            if (h_calc(a, b)       != R((u8)(a+1), (u8)(b^0x5a), (u8)(a|b), (u8)(a-b))) ++bad;
            if (h_glob()           != R(gb, (u8)(gb+1), (u8)(gb+2), (u8)(gb+3))) ++bad;
            if (h_use(a,b,c,d)     != R(a,b,c,d) + 1) ++bad;
            sink = 0;
            if (h_peek(a,b,c,d)    != R(a,b,c,d)) ++bad;
            if (sink               != (u32)a*k8 + b) ++bad;
            r = (u32)a*k8 + b;
            r = r*k8 + (u8)r;
            r = r*k8 + (u8)(r >> 8);
            if (h_self(a, b)       != r) ++bad;
            if (h_three(a,b,c)     != R(0,a,b,c)) ++bad;
            if (h_wide((u16)(x*257u+5), b, c) != (u32)(u16)(x*257u+5)*k16 + b*k8 + c) ++bad;
            if (h_shift16(a,b,c,d) != (((((u32)a << 8) | b) << 16 | c) << 8 | d)) ++bad;
            if (h_five(a,b,c,d,e)  != R(b,c,d,e)) ++bad;
            r = (u32)a*k8 + b;
            s = (u32)c*k8 + d;
            r = r*k8 + (u8)s;
            s = s*k8 + (u8)r;
            r = r*k8 + (u8)(s >> 8);
            want = r ^ s;
            if (h_two(a,b,c,d)     != want) ++bad;
        }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("accumulate-and-shift chains");
    suite_add_test(check);
    return suite_run();
}
