/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"
static unsigned int memory_access(void) { unsigned char memory[1000]; unsigned int i, pass; for (pass = 0; pass < 20; pass++) for (i = 0; i < 1000; i++) memory[i] = (unsigned char)i; return memory['o'] + memory['k']; }
static void test_m4memory(void) { assertEqual(memory_access(), 218U); }
int suite_m4memory(void) { suite_setup("M4 memory access benchmark"); suite_add_test(test_m4memory); return suite_run(); }
int main(void) { return suite_m4memory(); }
