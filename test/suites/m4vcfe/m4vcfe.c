/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static volatile unsigned long calls;
static unsigned int countup(void) { unsigned int i = 0; do i++; while (i <= 9999); return i; }
static unsigned int arithmetic(void) { unsigned int i = 0, j = 0; do { i++; j = i; j /= i; j *= i; j += i; j -= i; } while (i <= 9999); return j; }
static unsigned int logic_ops(void) { unsigned int i = 0, j = 0; do { i++; j = ~i; j &= i; j |= i; j ^= i; } while (i <= 9999); return j; }
static void bottom(void) { calls++; }
static void nest1(void) { bottom(); bottom(); }
static void nest2(void) { nest1(); nest1(); }
static void nest3(void) { nest2(); nest2(); }
static void nest4(void) { nest3(); nest3(); }
static void nest5(void) { nest4(); nest4(); }
static void nest6(void) { nest5(); nest5(); }
static void test_m4vcfe(void) { calls = 0; assertEqual(countup(), 10000U); assertEqual(arithmetic(), 10000U); assertEqual(logic_ops(), 0U); nest6(); assertEqual(calls, 64UL); }
int suite_m4vcfe(void) { suite_setup("M4 VCFe 24.0 benchmark kernels"); suite_add_test(test_m4vcfe); return suite_run(); }
int main(void) { return suite_m4vcfe(); }
