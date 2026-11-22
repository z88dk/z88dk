/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static int kadane(const int *values, unsigned int length) { int best = 0, current = 0; unsigned int i; for (i = 0; i < length; i++) { current += values[i]; if (current < 0) current = 0; if (current > best) best = current; } return best; }
static void test_m4kadane(void) { static const int values[] = {-9,2,3,4,-5,-5,4,-8,3,2,-9,2,3,4,-2,-1,4,-8,3,2,-9,5,6,7,-2,-1,5,-8,3,2,13}; unsigned int i; int total = 0; for (i = 0; i < 256; i++) total += kadane(values, 31); assertEqual(kadane(values, 20), 10); assertEqual(kadane(values, 31), 30); assertEqual(total, 7680); }
int suite_m4kadane(void) { suite_setup("M4 Kadane benchmark"); suite_add_test(test_m4kadane); return suite_run(); }
int main(void) { return suite_m4kadane(); }
