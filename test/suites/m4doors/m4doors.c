/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static unsigned int doors(unsigned int count) { unsigned char open[257]; unsigned int n, i, result = 0; for (i = 0; i <= count; i++) open[i] = 0; for (n = 1; n <= count; n++) for (i = n; i <= count; i += n) open[i] ^= 1; for (i = 1; i <= count; i++) result += open[i]; return result; }
static unsigned int doors_ptr(unsigned int count) { unsigned char open[257]; unsigned int n, i, result = 0; for (i = 0; i <= count; i++) open[i] = 0; for (n = 1; n <= count; n++) { unsigned char *p = open + n, *stop = open + count + 1; do { *p ^= 1; p += n; } while (p < stop); } for (i = 1; i <= count; i++) result += open[i]; return result; }
static void test_m4doors(void) { assertEqual(doors(100), 10U); assertEqual(doors_ptr(100), 10U); assertEqual(doors(256), 16U); assertEqual(doors_ptr(256), 16U); }
int suite_m4doors(void) { suite_setup("M4 doors benchmark"); suite_add_test(test_m4doors); return suite_run(); }
int main(void) { return suite_m4doors(); }
