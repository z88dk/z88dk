/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * by Paul Hsieh
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
   #define PUTS(a)           puts(a)
#else
   #define PRINTF2(a,b)
   #define PRINTF3(a,b,c)
   #define PUTS(a)
#endif

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      // enable printf %s
      #pragma output CLIB_OPT_PRINTF = 0x200
   #endif
   #ifdef COMMAND
      // enable scanf %d
      #pragma output CLIB_OPT_SCANF = 0x01
   #endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define IM 139968
#define IA   3877
#define IC  29573

double gen_random (double max) {
    static long last = 42;
    return max * (last = (last * IA + IC) % IM) / IM;
}

struct aminoacids {
    char c;
    double p;
};

/* Weighted selection from alphabet */

void makeCumulative (struct aminoacids * genelist, int count) {
    STATIC int i;
#ifdef STATIC
    STATIC double cp;
    cp = 0.0;
#else
    double cp = 0.0;
#endif

    for (i=0; i < count; i++) {
        cp += genelist[i].p;
        genelist[i].p = cp;
    }
}

char selectRandom (const struct aminoacids * genelist, int count) {
    STATIC int i, lo, hi;
#ifdef STATIC
    static double r;
    r = gen_random (1);
#else
    double r = gen_random (1);
#endif

    if (r < genelist[0].p) return genelist[0].c;

    lo = 0;
    hi = count-1;

    while (hi > lo+1) {
        i = (hi + lo) / 2;
        if (r < genelist[i].p) hi = i; else lo = i;
    }
    return genelist[hi].c;
}

/* Generate and write FASTA format */

#define LINE_LENGTH (60)

void makeRandomFasta (const char * id, const char * desc, const struct aminoacids * genelist, int count, int n) {
   STATIC int i, m;
#ifdef STATIC
   static int todo;
   static char pick[LINE_LENGTH+1];
   todo = n;
#else
   int todo = n;
   char pick[LINE_LENGTH+1];
#endif

   PRINTF3(">%s %s\n", id, desc);

   for (; todo > 0; todo -= LINE_LENGTH) {
//       char pick[LINE_LENGTH+1];
       if (todo < LINE_LENGTH) m = todo; else m = LINE_LENGTH;
       for (i=0; i < m; i++) pick[i] = selectRandom(genelist, count);
       pick[m] = '\0';
       PUTS(pick);
   }
}

void makeRepeatFasta (const char * id, const char * desc, const char *s, int n) {
   STATIC char * ss;
   STATIC int m;
#ifdef STATIC
   static int k;
   static int todo;
   static int kn;
   
   k = 0;
   todo = n;
   kn = strlen(s);
#else
   int k = 0, todo = n, kn = strlen(s);
#endif

   ss = (char *) malloc (kn + 1);
   memcpy (ss, s, kn+1);

   PRINTF3(">%s %s\n", id, desc);

   for (; todo > 0; todo -= LINE_LENGTH) {
       if (todo < LINE_LENGTH) m = todo; else m = LINE_LENGTH;

       while (m >= kn - k) {
           PRINTF2("%s", s+k);
           m -= kn - k;
           k = 0;
       }

       ss[k + m] = '\0';
       PUTS(ss+k);
       ss[k + m] = s[m+k];
       k += m;
   }

   free (ss);
}

/* Main -- define alphabets, make 3 fragments */

struct aminoacids iub[] = {
    { 'a', 0.27 },
    { 'c', 0.12 },
    { 'g', 0.12 },
    { 't', 0.27 },
    { 'B', 0.02 },
    { 'D', 0.02 },
    { 'H', 0.02 },
    { 'K', 0.02 },
    { 'M', 0.02 },
    { 'N', 0.02 },
    { 'R', 0.02 },
    { 'S', 0.02 },
    { 'V', 0.02 },
    { 'W', 0.02 },
    { 'Y', 0.02 }
};

#define IUB_LEN (sizeof (iub) / sizeof (struct aminoacids))

struct aminoacids homosapiens[] = {
    { 'a', 0.3029549426680 },
    { 'c', 0.1979883004921 },
    { 'g', 0.1975473066391 },
    { 't', 0.3015094502008 },
};

#define HOMOSAPIENS_LEN (sizeof (homosapiens) / sizeof (struct aminoacids))

char *alu =
   "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" \
   "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" \
   "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" \
   "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" \
   "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" \
   "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" \
   "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

int main (int argc, char * argv[]) {
    STATIC int n = 1000;

#ifdef COMMAND
    if (argc > 1) sscanf(argv[1], "%d", &n);
#endif

TIMER_START();

    makeCumulative (iub, IUB_LEN);
    makeCumulative (homosapiens, HOMOSAPIENS_LEN);

    makeRepeatFasta ("ONE", "Homo sapiens alu", alu, n*2);
    makeRandomFasta ("TWO", "IUB ambiguity codes", iub, IUB_LEN, n*3);
    makeRandomFasta ("THREE", "Homo sapiens frequency", homosapiens, HOMOSAPIENS_LEN, n*5);

TIMER_STOP();

    return 0;
}
