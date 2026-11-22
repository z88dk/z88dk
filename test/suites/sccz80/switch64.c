#include "test.h"
#include <stdio.h>
#include <stdlib.h>

int small(int x)
{
    switch (x) {
    case 0: return 1;
    case 1: return 2;
    case -1: return 3;
    case 100: return 4;
    default: return 5;
    }
}

/* 80cc still rounds these labels through double. */
#if !defined(__80CC) && !defined(__8080) && !defined(__8085) && !defined(__GBZ80)
long long wide(long long x)
{
    switch (x) {
    case 9007199254740992LL: return 1;
    case 9007199254740993LL: return 2;
    case 9223372036854775807LL: return 3;
    default: return 0;
    }
}
#endif

void test_small(void)
{
    assertEqual(small(0), 1);
    assertEqual(small(1), 2);
    assertEqual(small(-1), 3);
    assertEqual(small(100), 4);
    assertEqual(small(7), 5);
}

#if !defined(__80CC) && !defined(__8080) && !defined(__8085) && !defined(__GBZ80)
long wrapped(long x)
{
    switch (x) {
    case 2147483648L: return 1;
    default: return 0;
    }
}

long long unsigned_label(long long x)
{
    switch (x) {
    case 9223372036854775808ULL: return 1;
    default: return 0;
    }
}

void test_wide(void)
{
    assertEqual(wide(9007199254740992LL), 1);
    assertEqual(wide(9007199254740993LL), 2);
    assertEqual(wide(9223372036854775807LL), 3);
    assertEqual(wide(0), 0);
    assertEqual(wide(9007199254740994LL), 0);
    assertEqual(wrapped(-2147483648L), 1);
    assertEqual(wrapped(0L), 0);
    assertEqual(unsigned_label(-9223372036854775807LL - 1), 1);
    assertEqual(unsigned_label(1), 0);
}
#endif

int suite_switch64(void)
{
    suite_setup("64-bit case labels");
    suite_add_test(test_small);
#if !defined(__80CC) && !defined(__8080) && !defined(__8085) && !defined(__GBZ80)
    suite_add_test(test_wide);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_switch64();
    exit(res);
}
