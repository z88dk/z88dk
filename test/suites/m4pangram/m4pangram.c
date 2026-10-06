/* Adapted from M4_FORTH_Benchmark, Copyright (c) 2024 DW0RKiN.
 * https://codeberg.org/DW0RKiN/M4_FORTH_Benchmark (MIT License). */
#include "test.h"

#define REPS 1000

static int pangram(const char *str)
{
    unsigned char c;
    unsigned long alphabet = 0;

    while ((c = (unsigned char)*str++) != 0) {
        c |= 32;
        c -= 'a';
        if (c < 26)
            alphabet |= (unsigned long)1 << c;
    }

    return alphabet == 0x03ffffffUL;
}

static void test_m4pangram(void)
{
    static const char yes[] = "The five boxing wizards jump quickly.";
    static const char no[] = "The five boxing wizards jump.";
    unsigned int i, total = 0;

    assertEqual(pangram(yes), 1);
    assertEqual(pangram(no), 0);
    assertEqual(pangram(""), 0);

    for (i = 0; i < REPS; i++)
        total += pangram(yes);

    assertEqual(total, REPS);
}

int suite_m4pangram(void)
{
    suite_setup("M4 pangram benchmark");
    suite_add_test(test_m4pangram);
    return suite_run();
}

int main(void)
{
    return suite_m4pangram();
}
