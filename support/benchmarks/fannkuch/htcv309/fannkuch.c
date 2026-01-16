/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * converted to C by Joseph Piché
 * from Java version by Oleg Mazurov and Isaac Gouy
 *
 */

/*
 * COMMAND LINE DEFINES
 *
 * -DSTATIC
 * Make locals static.
 *
 * -DPRINTF
 * Enable printing of results.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 * -DINLINE
 * Compiler supports inline functions.
 *
 * -DCOMMAND
 * Enable reading of N from the command line.
 *
 */

#ifdef STATIC
#undef  STATIC
#define STATIC            static
#else
#define STATIC
#endif

#ifdef PRINTF
#define PRINTF2(a,b)      printf(a,b)
#define PRINTF3(a,b,c)    printf(a,b,c)
#else
#define PRINTF2(a,b)
#define PRINTF3(a,b,c)    c
#endif

#ifdef TIMER
#define TIMER_START()     intrinsic_label(TIMER_START)
#define TIMER_STOP()      intrinsic_label(TIMER_STOP)
#else
#define TIMER_START()
#define TIMER_STOP()
#endif

#ifdef INLINE
#undef  INLINE
#define INLINE            inline
#else
#define INLINE
#endif


#include <stdio.h>
#include <stdlib.h>

#define N_MAX  16

int perm [N_MAX];
int perm1[N_MAX];
int count[N_MAX];

INLINE static int max(int a, int b)
{
    return a > b ? a : b;
}

int fannkuchredux(int n)
{
    STATIC int maxFlipsCount = 0;
    STATIC int permCount = 0;
    STATIC int checksum = 0;

    STATIC int i;
    STATIC int r;

    r = n;

    for (i=0; i<n; i+=1)
        perm1[i] = i;

    while (1) {
        int flipsCount = 0;
        int k;

        while (r != 1) {
            count[r-1] = r;
            r -= 1;
        }

        for (i=0; i<n; i+=1)
            perm[i] = perm1[i];

        while ( !((k = perm[0]) == 0) ) {
            int k2 = (k+1) >> 1;
            for (i=0; i<k2; i++) {
                int temp = perm[i]; perm[i] = perm[k-i]; perm[k-i] = temp;
            }
            flipsCount += 1;
        }

        maxFlipsCount = max(maxFlipsCount, flipsCount);
        checksum += permCount % 2 == 0 ? flipsCount : -flipsCount;

        /* Use incremental change to generate another permutation */
        while (1) {
            int perm0 = perm1[0];
            if (r == n) {
                PRINTF2("%d\n", checksum);
                return maxFlipsCount;
            }

            i = 0;
            while (i < r) {
                int j = i + 1;
                perm1[i] = perm1[j];
                i = j;
            }
            perm1[r] = perm0;
            count[r] = count[r] - 1;
            if (count[r] > 0) break;
            r++;
        }
        permCount++;
    }
}

int main(int argc, char *argv[])
{
#ifdef COMMAND
    int n = argc > 1 ? atoi(argv[1]) : 7;
#else
    int n = 7;
#endif

    if (n > N_MAX) n = N_MAX;

TIMER_START();

    PRINTF3("Pfannkuchen(%d) = %d\n", n, fannkuchredux(n));

TIMER_STOP();

    return 0;
}
