/*
 * sieve.c — Sieve of Eratosthenes prime count, compiler comparison bench.
 *
 * Classic BYTE-magazine sieve: mark composites in a byte flag array over
 * [2, SIZE) and count the primes that survive. The hot inner loop is pure
 * unsigned-int arithmetic + a strided byte-array walk (flags[k] with
 * k += i), so it exercises int add/compare, the `!flags[k]` byte load and
 * the flags[k]=1 byte store — a good foil for pointer/index codegen.
 *
 * Uses the (n+1)^2 = n^2 + 2n + 1 recurrence to advance the square bound
 * without a multiply, keeping the outer test a plain 16-bit compare.
 *
 * SIZE and the expected prime count are host-verified: primes in [2,7999].
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "test.h"

#define SIZE 8000

static unsigned char flags[SIZE];

/* Count primes in [2, SIZE-1]. `count` starts at every candidate and is
   decremented once per composite the sieve reaches. */
static unsigned int sieve_count(void)
{
    unsigned int i, i_sq, k, count;

    memset(flags, 0, SIZE);

    count = SIZE - 2;
    i_sq = 4;
    for (i = 2; i_sq < SIZE; ++i) {
        if (!flags[i]) {
            for (k = i_sq; k < SIZE; k += i) {
                count   -= !flags[k];
                flags[k] = 1;
            }
        }
        i_sq += i + i + 1;      /* (n+1)^2 = n^2 + 2n + 1 */
    }
    return count;
}

static void sieve_run(void)
{
    assertEqual(sieve_count(), 1007U);   /* primes in [2,7999], host-verified */
}

int suite_sieve(void)
{
    suite_setup("Sieve Tests");
    suite_add_test(sieve_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_sieve();
    exit(res);
}
