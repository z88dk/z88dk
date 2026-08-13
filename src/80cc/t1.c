#include "test.h"

/* Bisect tier 1: each test isolates one IR feature.
   Anything that fails reveals a miscompile in that feature. */

static int t_param(int n)        { return n; }
static int t_add(int a, int b)   { return a + b; }
static int t_xor(int a, int b)   { return a ^ b; }
static int t_shl_const(int x)    { return x << 3; }    /* SHL with const RHS */
static int t_shl_one(int x)      { return x << 1; }    /* SHL by 1 */

static int t_local_init(int n) { int x = n; return x; }
static int t_local_assign(int n) { int x; x = n; return x; }
static int t_local_compound(int n) { int x = 7; x ^= n; return x; }

static int t_ternary_expr(int x) { return x ? 100 : 200; }

static int t_while(int n) {
    int s = 0;
    int i = 0;
    while (i < n) {
        s = s + i;
        i = i + 1;
    }
    return s;
}

/* Pointer + deref */
static int t_deref(unsigned char *p) { return *p; }
static int t_deref_cast(unsigned char *p) { return (unsigned int)*p; }
static int t_deref_postinc(unsigned char *p, int *out) {
    int v = *p++;
    *out = (int)(p - (p-1));  /* should be 1 (1 byte step) — but pointer arith! */
    return v;
}
static int t_postinc_simple(int n) {
    int i = n;
    int o = i++;     /* o = n, i = n+1 */
    return o * 100 + i;
}

static unsigned char buf[3] = { 0x42, 0x84, 0xC8 };

static void run_tests(void) {
    assertEqual(t_param(42), 42);
    assertEqual(t_add(7, 3), 10);
    assertEqual(t_xor(0x5555, 0xAAAA), 0xFFFF);
    assertEqual(t_shl_const(2), 16);
    assertEqual(t_shl_one(5), 10);

    assertEqual(t_local_init(99), 99);
    assertEqual(t_local_assign(99), 99);
    assertEqual(t_local_compound(0x42), 7 ^ 0x42);

    assertEqual(t_ternary_expr(0), 200);
    assertEqual(t_ternary_expr(1), 100);

    assertEqual(t_while(5), 0+1+2+3+4);  /* 10 */
    assertEqual(t_while(0), 0);

    assertEqual(t_deref(buf), 0x42);
    assertEqual(t_deref_cast(buf), 0x42);

    assertEqual(t_postinc_simple(7), 7*100 + 8);
}

int suite_t(void) {
    suite_setup("IR bisect tier 1");
    suite_add_test(run_tests);
    return suite_run();
}

int main(void) { return suite_t(); }
