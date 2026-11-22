/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static unsigned int gcd_sub(unsigned int a, unsigned int b) { if (!a) return b ? b : 1; while (b) { if (a > b) { unsigned int t = a; a = b; b = t; } b -= a; } return a; }
static unsigned int gcd_equal(unsigned int a, unsigned int b) { if (!(a | b)) return 1; if (!a) return b; if (!b) return a; while (a != b) { if (a > b) a -= b; else b -= a; } return a; }
static void test_m4gcd(void) { unsigned int i, total = 0; for (i = 1; i <= 64; i++) { total += gcd_sub(i * 37U, i * 19U); total += gcd_equal(i * 41U, i * 23U); } assertEqual(gcd_sub(84, 30), 6U); assertEqual(gcd_equal(1071, 462), 21U); assertEqual(total, 4160U); }
int suite_m4gcd(void) { suite_setup("M4 GCD benchmark"); suite_add_test(test_m4gcd); return suite_run(); }
int main(void) { return suite_m4gcd(); }
