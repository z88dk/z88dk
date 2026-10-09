/* Word add and subtract with a global operand: the global is read with
 * `ld de,(g)` at the operation, HL keeps the other operand. Results are
 * checked in plain functions, in loops that keep other values in registers,
 * with the global read twice, and with a store back to the same global.
 */
#include "test.h"

int ga, gb, gc;
static int sink;

static int add_pg(int p)       { return p + ga; }
static int sub_pg(int p)       { return p - ga; }
static int sub_gp(int p)       { return ga - p; }
static int add_gg(void)        { return ga + gb; }
static int sub_gg(void)        { return ga - gb; }
static void acc(void)          { ga += gb; }
static void dec(void)          { ga -= gb; }
static int acc_cmp(void)       { ga += gb; return ga == 56; }
static int twice(int p)        { return (p + ga) + (p - ga) + ga; }

/* an accumulator and a counter keep other registers busy */
static int loop(int n)
{
    int i, s = 0;
    for (i = 0; i < n; i++) {
        s += ga;
        s -= gb;
        sink += i;
    }
    return s;
}

static long garr[8];
static long *gp = garr;
static void store_idx(int i)    { gp[i] = -16L; gp[i + 1] = 16L; }
static int shl_add(int p)       { return ga + (p << 2) + p; }
static int shl_sub(int p)       { return (p << 2) - ga; }
static int shl_addr(int p)      { return (p << 2) + ga; }
static int shl_mul(int p)       { return ga + p * 6; }
static int via_call(int p)      { return ga + p * 3 + gb; }

static int chain(int p, int q) { return (p + ga) * 3 + (q - gb); }

static void check(void)
{
    ga = 100; gb = 7; gc = -3;
    assertEqual(add_pg(5), 105);
    assertEqual(sub_pg(5), -95);
    assertEqual(sub_gp(5), 95);
    assertEqual(add_gg(), 107);
    assertEqual(sub_gg(), 93);
    acc();
    assertEqual(ga, 107);
    dec();
    dec();
    assertEqual(ga, 93);
    ga = 49;
    assertEqual(acc_cmp(), 1);
    assertEqual(ga, 56);
    assertEqual(acc_cmp(), 0);
    ga = 1000; gb = -400;
    assertEqual(add_pg(-1), 999);
    assertEqual(twice(10), (10 + 1000) + (10 - 1000) + 1000);
    assertEqual(loop(5), 5 * 1000 - 5 * -400);
    assertEqual(chain(2, 3), (2 + 1000) * 3 + (3 + 400));
    ga = 1000; gb = 5;
    store_idx(2);
    assertEqual(garr[2], -16L);
    assertEqual(garr[3], 16L);
    store_idx(5);
    assertEqual(garr[5], -16L);
    assertEqual(garr[6], 16L);
    assertEqual(garr[2], -16L);
    assertEqual(shl_add(3), 1000 + 12 + 3);
    assertEqual(shl_sub(3), 12 - 1000);
    assertEqual(shl_addr(3), 12 + 1000);
    assertEqual(shl_mul(3), 1000 + 18);
    assertEqual(via_call(3), 1000 + 9 + 5);
    ga = 32767; gb = 1;
    assertEqual(add_gg(), -32768);
    ga = -32768;
    assertEqual(sub_gg(), 32767);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word add and subtract with a global operand");
    suite_add_test(check);
    return suite_run();
}
