/* AND/OR/XOR of two promoted bytes, widened to a long, an int or an unsigned.
 * The result's sign comes from the operand types: unsigned and unsigned is never
 * negative, signed and signed may be, and mixed OR/XOR takes its sign from the
 * signed operand. The reference works on 16-bit two's complement values one bit
 * at a time with subtraction only.
 */
#include "test.h"

typedef unsigned char u8;
typedef signed char s8;
typedef unsigned short u16;

static const u16 pw[16] = { 32768u, 16384, 8192, 4096, 2048, 1024, 512, 256,
                            128, 64, 32, 16, 8, 4, 2, 1 };

/* op: 0 and, 1 or, 2 xor, on the 16-bit patterns of x and y; result as a signed int */
static long ref(int x, int y, int op)
{
    u16 a = (u16)x, b = (u16)y, r = 0;
    int i;
    for (i = 0; i < 16; ++i) {
        int ab = 0, bb = 0, rb;
        if (a >= pw[i]) { ab = 1; a = (u16)(a - pw[i]); }
        if (b >= pw[i]) { bb = 1; b = (u16)(b - pw[i]); }
        rb = (op == 0) ? (ab && bb) : (op == 1) ? (ab || bb) : (ab != bb);
        if (rb) r = (u16)(r + pw[i]);
    }
    return (r >= 32768u) ? (long)r - 65536L : (long)r;
}

/* unsigned x unsigned */
static long uu_and(u8 a, u8 b) { return (long)(a & b); }
static long uu_or(u8 a, u8 b)  { return (long)(a | b); }
static long uu_xor(u8 a, u8 b) { return (long)(a ^ b); }
static int  uu_or_i(u8 a, u8 b)  { return (int)(a | b); }
static unsigned uu_xor_u(u8 a, u8 b) { return (unsigned)(a ^ b); }
static long uu_or80(u8 a)      { return (long)(a | 0x80); }
static long uu_xor80(u8 a)     { return (long)(a ^ 0x80); }
static long uu_nest(u8 a, u8 b, u8 c) { return (long)(a | b | c); }
/* signed x signed */
static long ss_and(s8 a, s8 b) { return (long)(a & b); }
static long ss_or(s8 a, s8 b)  { return (long)(a | b); }
static long ss_xor(s8 a, s8 b) { return (long)(a ^ b); }
/* mixed */
static long us_and(u8 a, s8 b) { return (long)(a & b); }
static long us_or(u8 a, s8 b)  { return (long)(a | b); }
static long us_xor(u8 a, s8 b) { return (long)(a ^ b); }
/* byte against a literal */
static long u_orneg(u8 a)      { return (long)(a | -2); }
static long s_or80(s8 a)       { return (long)(a | 0x40); }
static long s_xorneg(s8 a)     { return (long)(a ^ -128); }

static void check(void)
{
    static const u8 pat[] = { 0x00, 0x01, 0x7f, 0x80, 0x81, 0xaa, 0xfe, 0xff };
    int bad = 0, i, j, k;
    for (i = 0; i < 8; ++i) {
        u8 a = pat[i];
        s8 sa = (s8)pat[i];
        if (uu_or80(a)  != ref(a, 0x80, 1)) ++bad;
        if (uu_xor80(a) != ref(a, 0x80, 2)) ++bad;
        if (u_orneg(a)  != ref(a, -2, 1))   ++bad;
        if (s_or80(sa)  != ref(sa, 0x40, 1)) ++bad;
        if (s_xorneg(sa) != ref(sa, -128, 2)) ++bad;
        for (j = 0; j < 8; ++j) {
            u8 b = pat[j];
            s8 sb = (s8)pat[j];
            if (uu_and(a, b) != ref(a, b, 0)) ++bad;
            if (uu_or(a, b)  != ref(a, b, 1)) ++bad;
            if (uu_xor(a, b) != ref(a, b, 2)) ++bad;
            if (uu_or_i(a, b) != (int)ref(a, b, 1)) ++bad;
            if (uu_xor_u(a, b) != (unsigned)ref(a, b, 2)) ++bad;
            if (ss_and(sa, sb) != ref(sa, sb, 0)) ++bad;
            if (ss_or(sa, sb)  != ref(sa, sb, 1)) ++bad;
            if (ss_xor(sa, sb) != ref(sa, sb, 2)) ++bad;
            if (us_and(a, sb) != ref(a, sb, 0)) ++bad;
            if (us_or(a, sb)  != ref(a, sb, 1)) ++bad;
            if (us_xor(a, sb) != ref(a, sb, 2)) ++bad;
            for (k = 0; k < 8; k += 3)
                if (uu_nest(a, b, pat[k]) != ref((int)ref(a, b, 1), pat[k], 1)) ++bad;
        }
    }
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bitwise ops on bytes, widened");
    suite_add_test(check);
    return suite_run();
}
