/* [slot-bitop-de / mask-shl-a] The post-render folds that replaced copt #285r
 * and #285q. Each fires only when the register its rewrite leaves different
 * (DE, or A and S/P/V/H) is dead after it; the variants that read DE, the
 * masked byte or the flags again must keep the original sequence. */
#include "test.h"

#define ST_XOR_1234 1164
#define ST_XOR_BEEF 1290

struct rec { int a, b, c, d; };

/* localbench's record(): `r.a ^ r.b` between two frame slots, DE dead after
   (slot-bitop-de fires on z80/z180 fp). */
static unsigned int st_xor(unsigned int seed)
{
    struct rec r;
    int i;
    r.a = (int)(seed & 255u);
    r.b = (int)((seed >> 4) & 255u);
    r.c = (int)((seed >> 8) & 255u);
    r.d = 0;
    for (i = 0; i < 8; i++) {
        r.d = (r.d + r.a) & 4095;
        r.a = (r.a ^ r.b) & 255;
        r.b = (r.b + r.c + i) & 255;
        r.c = (r.c ^ r.d) & 255;
    }
    return (unsigned int)((r.a + r.b + r.c + r.d) & 0xffff);
}

static int st_reuse(int n)
{
    struct rec r;
    int i, t = 0;
    r.a = 9; r.b = 0x33; r.c = 5; r.d = 0x0f;
    for (i = 0; i < n; i++) {
        r.a = r.a ^ r.b;                /* DE (r.b) still wanted: */
        t += r.b + r.d;                 /* read again here */
        r.b = (r.b | r.d) + i;
    }
    return r.a + t + r.b;
}

typedef unsigned int (*opf)(unsigned int, unsigned int);
static unsigned int o_add(unsigned int a, unsigned int b) { return a + b; }
static unsigned int o_sub(unsigned int a, unsigned int b) { return a - b; }
static unsigned int o_xor(unsigned int a, unsigned int b) { return a ^ b; }
static unsigned int o_and(unsigned int a, unsigned int b) { return a & b; }
static opf ops[8] = { o_add, o_sub, o_xor, o_and, o_add, o_sub, o_xor, o_and };

/* callbench's dispatch(): `ops[k & 7u]` doubles the masked byte, then calls
   through the table, so A and the flags are dead (mask-shl-a fires on z80 fp). */
static unsigned int dispatch(unsigned int k, unsigned int a, unsigned int b)
{
    return ops[k & 7u](a, b);
}

static int ibuf[64];

static long widen(unsigned char k)
{
    return (long)ibuf[k & 63];
}

static int mask_reuse(unsigned char k)
{
    unsigned char m = k & 15;
    int v = ibuf[m];
    return v + m;                       /* the masked byte read again */
}

static void test_postfold(void)
{
    int i;
    for (i = 0; i < 64; i++) ibuf[i] = (i * 37) - 600;
    assertEqual(st_xor(0x1234), ST_XOR_1234);
    assertEqual(st_xor(0xbeef), ST_XOR_BEEF);
    assertEqual(st_reuse(7), 987);
    assertEqual(dispatch(0, 7, 5), 12);
    assertEqual(dispatch(9, 7, 5), 2);
    assertEqual(dispatch(14, 6, 3), 5);
    assertEqual(dispatch(255, 6, 3), 2);
    assertEqual((int)widen(1), -563);
    assertEqual((int)widen(200), -304);
    assertEqual(mask_reuse(0x1f), -30);
}

int main(int argc, char *argv[])
{
    suite_setup("postfold");
    suite_add_test(test_postfold);
    return suite_run();
}
