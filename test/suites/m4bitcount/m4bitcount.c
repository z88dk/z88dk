/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static unsigned int popcount(unsigned int value) { unsigned int count = 0; while (value) { count += value & 1U; value >>= 1; } return count; }
static unsigned int popcount_kernighan(unsigned int value) { unsigned int count = 0; while (value) { value &= value - 1U; count++; } return count; }
static void test_m4bitcount(void) { unsigned int i, total = 0; for (i = 0; i < 512; i++) { total += popcount(i * 251U); total += popcount_kernighan(i * 179U); } assertEqual(popcount(0xF0F0U), 8U); assertEqual(popcount_kernighan(0xF0F0U), 8U); assertEqual(total, 8043U); }
int suite_m4bitcount(void) { suite_setup("M4 bitcount benchmark"); suite_add_test(test_m4bitcount); return suite_run(); }
int main(void) { return suite_m4bitcount(); }
