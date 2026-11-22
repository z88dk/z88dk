/* __builtin_choose_expr and __builtin_types_compatible_p are compile-time selections.
 * __builtin_choose_expr takes one of two expressions at compile time.
 * __builtin_expect passes its value through at its own width; __builtin_assume
 * changes nothing; __builtin_unreachable in a switch drops that case's compare. */
#include "test.h"

static volatile int sink;

static int  disp(unsigned char op)
{
    switch (op & 3) {
    case 0: return 10;
    case 1: return 20;
    case 2: return 30;
    case 3: return 40;
    default: __builtin_unreachable();
    }
}

static int  disp_wide(unsigned int op)
{
    switch (op & 7) {
    case 0: return 1;
    case 1: return 2;
    case 2: return 3;
    case 3: return 4;
    case 4: return 5;
    case 5: return 6;
    case 6: return 7;
    case 7: return 8;
    default: __builtin_unreachable();
    }
}

static int  one_case(int x)
{
    switch (x & 0) {
    case 0: return 77;
    default: __builtin_unreachable();
    }
}

static int  dead_case(int x)
{
    switch (x & 3) {
    case 0: return 1;
    case 1: __builtin_unreachable();
    case 2: return 3;
    default: return 4;
    }
}

static int  long_disp(unsigned long v)
{
    switch ((int)(v & 1)) {
    case 0: return 100;
    case 1: return 200;
    default: __builtin_unreachable();
    }
}

static long ex_long(long x)            { return __builtin_expect(x, 0); }
static int  ex_int(int x)              { return __builtin_expect(x, 1); }
static int  ex_cond(int x)             { if (__builtin_expect(x < 0, 0)) return -1; return x * 2; }
static int  ex_not(void *p)            { return __builtin_expect(!!p, 1); }
static int  as(int x)                  { __builtin_assume(x >= 0); return x + 1; }
static int  ch_a(int x)                { return __builtin_choose_expr(1, x + 1, x - 1); }
static int  ch_b(int x)                { return __builtin_choose_expr(0, x + 1, x - 1); }
static int  ch_c(int x)                { return __builtin_choose_expr(sizeof(int) == 2 || sizeof(int) == 4, x * 2, x * 3); }
static long ch_d(long x)               { return __builtin_choose_expr(1, x, 0); }
static int  ch_e(int *p)               { return __builtin_choose_expr(0, *p, 5); }
typedef int myint;
struct SA { int a; };
struct SB { int a; };
static int  tc(void)
{
    return __builtin_types_compatible_p(int, int)
         | __builtin_types_compatible_p(int, long) << 1
         | __builtin_types_compatible_p(int, myint) << 2
         | __builtin_types_compatible_p(char, unsigned char) << 3
         | __builtin_types_compatible_p(int *, char *) << 4
         | __builtin_types_compatible_p(int *, int *) << 5
         | __builtin_types_compatible_p(int [3], int *) << 6
         | __builtin_types_compatible_p(struct SA, struct SB) << 7
         | __builtin_types_compatible_p(struct SA, struct SA) << 8
         | __builtin_types_compatible_p(const int, int) << 9
         | __builtin_types_compatible_p(unsigned, unsigned int) << 10;
}
static int  after_call(int x)          { sink = x; if (x == 5) { sink = 9; } return sink; }

static void test_hints(void)
{
    assertEqual(disp(0), 10);
    assertEqual(disp(1), 20);
    assertEqual(disp(2), 30);
    assertEqual(disp(3), 40);
    assertEqual(disp(7), 40);
    assertEqual(disp_wide(0), 1);
    assertEqual(disp_wide(5), 6);
    assertEqual(disp_wide(7), 8);
    assertEqual(one_case(9), 77);
    assertEqual(dead_case(0), 1);
    assertEqual(dead_case(2), 3);
    assertEqual(dead_case(3), 4);
    assertEqual(long_disp(0x10000UL), 100);
    assertEqual(long_disp(0x10001UL), 200);
    assertEqual(ex_long(0x12345678L) == 0x12345678L, 1);
    assertEqual(ex_long(0x10000L) != 0, 1);
    assertEqual(ex_int(-3), -3);
    assertEqual(ex_cond(-2), -1);
    assertEqual(ex_cond(4), 8);
    assertEqual(ex_not((void *)0), 0);
    assertEqual(ex_not((void *)&sink), 1);
    assertEqual(as(4), 5);
    assertEqual(ch_a(10), 11);
    assertEqual(ch_b(10), 9);
    assertEqual(ch_c(10), 20);
    assertEqual(ch_d(0x12345678L) == 0x12345678L, 1);
    assertEqual(ch_e((int *)0), 5);
    assertEqual(tc(), 1 | 4 | 32 | 256 | 512 | 1024);
    assertEqual(__builtin_choose_expr(__builtin_types_compatible_p(long, int), 1, 2), 2);
    assertEqual(__builtin_choose_expr(__builtin_types_compatible_p(myint, int), 1, 2), 1);
    assertEqual(after_call(5), 9);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("builtin hints");
    suite_add_test(test_hints);
    return suite_run();
}
