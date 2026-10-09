/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static unsigned int josephus(unsigned int people, unsigned int step) { unsigned int survivor = 0, n; for (n = 1; n <= people; n++) survivor = (survivor + step) % n; return survivor; }
static unsigned int josephus_no_mod(unsigned int people, unsigned int step) { unsigned int survivor = 0, n; for (n = 1; n <= people; n++) { survivor += step; while (survivor >= n) survivor -= n; } return survivor; }
static void test_m4josephus(void) { unsigned int i, total = 0; for (i = 1; i <= 12; i++) { total += josephus(400U + i * 13U, i + 2U); total += josephus_no_mod(400U + i * 13U, i + 2U); } assertEqual(josephus(7, 3), 3U); assertEqual(josephus(41, 3), 30U); assertEqual(total, 5894U); }
int suite_m4josephus(void) { suite_setup("M4 Josephus benchmark"); suite_add_test(test_m4josephus); return suite_run(); }
int main(void) { return suite_m4josephus(); }
