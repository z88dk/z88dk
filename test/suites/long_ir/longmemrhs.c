/* A long ADD/SUB/AND/OR/XOR whose right (or, for the commutative ones, left)
 * operand is a global read once: the operand is read in place. Checked against
 * the same arithmetic done on a copy that cannot be read in place.
 */
#include "test.h"

static long ga, gb, gc, gt;
static unsigned long ua, ub, uc;
static long vals[] = { 0L, 1L, -1L, 255L, 256L, 65535L, 65536L, 0x7fffffffL,
                       -0x7fffffffL - 1, 0x12345678L, -0x12345678L, 0x00ff00ffL };
#define NV ((int)(sizeof vals / sizeof vals[0]))

static void op_add(void)  { ga += gb; }
static void op_sub(void)  { ga -= gb; }
static void op_and(void)  { ga &= gb; }
static void op_or(void)   { ga |= gb; }
static void op_xor(void)  { ga ^= gb; }
static void op_sum3(void) { gc = ga + gb; }
static void op_dif3(void) { gc = ga - gb; }
static void op_and3(void) { gc = ga & gb; }
static void op_mix(void)  { gc = ga + gb - gt; }
static void op_use(void)  { ga += gb; gt = ga; }
static void op_usel(void) { gc = gb + ga; }
static void op_unsg(void) { uc = ua + ub; ua = uc - ub; }

static void self_add(void) { ga += ga; }
static void self_sub(void) { ga -= ga; }
static void self_xor(void) { ga ^= ga; }
static void self_and(void) { ga &= ga; }

static long ref(int op, long x, long y)
{
    unsigned long ux = (unsigned long)x, uy = (unsigned long)y;
    switch (op) {
    case 0: return (long)(ux + uy);
    case 1: return (long)(ux - uy);
    case 2: return x & y;
    case 3: return x | y;
    default: return x ^ y;
    }
}

static int run(void)
{
    int bad = 0, i, j;
    void (*two[5])(void) = { op_add, op_sub, op_and, op_or, op_xor };
    for (i = 0; i < NV; i++)
        for (j = 0; j < NV; j++) {
            int k;
            for (k = 0; k < 5; k++) {
                ga = vals[i]; gb = vals[j];
                two[k]();
                if (ga != ref(k, vals[i], vals[j])) bad++;
                if (gb != vals[j]) bad++;
            }
            if (j == 0) {
                ga = vals[i]; self_add(); if (ga != ref(0, vals[i], vals[i])) bad++;
                ga = vals[i]; self_sub(); if (ga != 0) bad++;
                ga = vals[i]; self_xor(); if (ga != 0) bad++;
                ga = vals[i]; self_and(); if (ga != vals[i]) bad++;
            }
            ga = vals[i]; gb = vals[j]; op_sum3();
            if (gc != ref(0, vals[i], vals[j]) || ga != vals[i]) bad++;
            op_dif3();
            if (gc != ref(1, vals[i], vals[j])) bad++;
            op_and3();
            if (gc != ref(2, vals[i], vals[j])) bad++;
            gt = 0x01020304L; op_mix();
            if (gc != (long)((unsigned long)ref(0, vals[i], vals[j]) - 0x01020304UL)) bad++;
            ga = vals[i]; gb = vals[j]; gt = 0; op_use();
            if (gt != ref(0, vals[i], vals[j]) || ga != gt) bad++;
            ga = vals[i]; gb = vals[j]; op_usel();
            if (gc != ref(0, vals[i], vals[j])) bad++;
            ua = (unsigned long)vals[i]; ub = (unsigned long)vals[j]; op_unsg();
            if (ua != (unsigned long)vals[i] || uc != (unsigned long)ref(0, vals[i], vals[j])) bad++;
        }
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long operation reading a global in place");
    suite_add_test(check);
    return suite_run();
}
