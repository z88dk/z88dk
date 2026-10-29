/* ORDERED COMPARES OF TWO UNSIGNED BYTES ARE DONE IN A, NOT WIDENED.
 *
 *     for (i = 0; i < n; i++)     j < i     a >= b     a > b     a <= b
 *
 * Both operands are bytes, so `ld a,x; cp y` gives the same answer as the
 * zero-extended 16-bit compare. Values either side of 127/128 are used so a
 * signed compare slipping in shows up, and the operands come from globals,
 * parameters and loop counters so each home (register, slot, global) is read.
 */
#include "test.h"

static unsigned char ga, gb;
static unsigned char vals[8] = { 0, 1, 126, 127, 128, 129, 254, 255 };

static int lt(unsigned char a, unsigned char b) { return a < b; }
static int le(unsigned char a, unsigned char b) { return a <= b; }
static int gt(unsigned char a, unsigned char b) { return a > b; }
static int ge(unsigned char a, unsigned char b) { return a >= b; }

static int blt(unsigned char a, unsigned char b) { if (a < b) return 1; return 0; }
static int ble(unsigned char a, unsigned char b) { if (a <= b) return 1; return 0; }
static int bgt(unsigned char a, unsigned char b) { if (a > b) return 1; return 0; }
static int bge(unsigned char a, unsigned char b) { if (a >= b) return 1; return 0; }

static int glt(void) { if (ga < gb) return 1; return 0; }
static int gle(void) { if (ga <= gb) return 1; return 0; }
static int ggt(void) { if (ga > gb) return 1; return 0; }
static int gge(void) { if (ga >= gb) return 1; return 0; }
static int vlt(void) { return ga < gb; }
static int vge(void) { return ga >= gb; }

static int count_up(unsigned char n)
{
    unsigned char i;
    int s = 0;
    for (i = 0; i < n; i++) s++;
    return s;
}

static int count_global(void)
{
    unsigned char i;
    int s = 0;
    for (i = 0; i < gb; i++) s++;
    return s;
}

static int tri(unsigned char n)
{
    unsigned char i, j;
    int s = 0;
    for (i = 0; i < n; i++)
        for (j = 0; j < i; j++)
            s++;
    return s;
}

static int sum_below(unsigned char lim)
{
    unsigned char i;
    int s = 0;
    for (i = 0; i < 8; i++)
        if (vals[i] < lim) s += 1;
    return s;
}

void test_bytecmprr(void)
{
    int x, y;
    for (x = 0; x < 8; x++) {
        for (y = 0; y < 8; y++) {
            unsigned char a = vals[x], b = vals[y];
            int rl = a < b, rle = a <= b, rg = a > b, rge = a >= b;
            assertEqual(lt(a, b), rl);   assertEqual(le(a, b), rle);
            assertEqual(gt(a, b), rg);   assertEqual(ge(a, b), rge);
            assertEqual(blt(a, b), rl);  assertEqual(ble(a, b), rle);
            assertEqual(bgt(a, b), rg);  assertEqual(bge(a, b), rge);
            ga = a; gb = b;
            assertEqual(glt(), rl);      assertEqual(gle(), rle);
            assertEqual(ggt(), rg);      assertEqual(gge(), rge);
            assertEqual(vlt(), rl);      assertEqual(vge(), rge);
        }
    }

    assertEqual(count_up(0), 0);
    assertEqual(count_up(1), 1);
    assertEqual(count_up(200), 200);
    assertEqual(count_up(255), 255);
    gb = 0;   assertEqual(count_global(), 0);
    gb = 130; assertEqual(count_global(), 130);
    gb = 255; assertEqual(count_global(), 255);
    assertEqual(tri(0), 0);
    assertEqual(tri(1), 0);
    assertEqual(tri(5), 10);
    assertEqual(tri(20), 190);
    assertEqual(sum_below(0), 0);
    assertEqual(sum_below(128), 4);
    assertEqual(sum_below(255), 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("ordered compares of two unsigned bytes");
    suite_add_test(test_bytecmprr);
    return suite_run();
}
