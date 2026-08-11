/* Symbol-address add whose INDEX stays live in DE (copt #ADDR).
 *
 * `#ADDR` folds `ex de,hl / ld hl,_sym / add hl,de` into `ld de,_sym / add hl,de`
 * — the add is commutative, so the address is the same. What differs is the
 * RESIDUE: the original leaves the index in DE, the folded form leaves the
 * symbol there. The rule assumes "DE is dead after"; when it is not, the fold
 * hands the array base back where the index is expected.
 *
 * 8085 is the target that produces that shape, because it is the only one whose
 * sp-relative word load is LDSI+LHLX (`ld de,sp+N; ld hl,(de); ex de,hl`) —
 * the index lands in DE and STAYS there across the add, to be reclaimed by a
 * later `ex de,hl`. Hence `%notcpu 8085` on the rule.
 *
 * THE LOOP MUST BE IN main(). In a leaf function the index stays at
 * top-of-stack (`pop hl; push hl`), the LDSI+LHLX load never happens and #ADDR
 * has nothing to match — four reduced versions of this test all passed with the
 * fix reverted before that was understood. The helpers below cover the shape at
 * other widths but do NOT catch the bug on their own; main_count does.
 *
 * Self-verifying with explicit constants; no printf (it perturbs allocation).
 * Run on 8085 (the shape), 8080 (same clib family, must be unaffected) and z80
 * sp+fp. Without `%notcpu 8085` on #ADDR the 8085 build HANGS rather than
 * printing a wrong answer -- the corrupted index walks the loop off its bound.
 */
#include "test.h"

#define N  8000      /* matches sieve/z88dk-classic: the shape needs the scale */
#define WN 64        /* the word array stays small — 8000 words is 16K of bss */

static unsigned char flags[N];
static unsigned int  words[WN];

/* The faithful shape: sieve's nested loop, four live locals. Fewer locals and
   the index stays at TOS (`pop hl; push hl`), the LDSI+LHLX load never happens
   and #ADDR has nothing to match — the reduced single-loop versions below do
   NOT reproduce, which is why this one is here.
   Returns the number of primes in [2,N-1] = 18 for N=64. */
static unsigned int sieve_like(void)
{
    unsigned int i, i_sq, k, count;

    count = (unsigned int)(N - 2);
    i_sq  = 4;
    for (i = 2; i_sq < (unsigned int)N; ++i) {
        if (!flags[i]) {
            for (k = i_sq; k < (unsigned int)N; k += i) {
                count -= !flags[k];
                flags[k] = 1;
            }
        }
        i_sq = (unsigned int)(i_sq + i + i + 1u);
    }
    return count;
}

/* sieve's inner loop alone: index in a stack slot, global array, index reused
   after the indexed store. */
static unsigned int mark_walk(unsigned int start, unsigned int step)
{
    unsigned int k, seen = 0;

    for (k = start; k < (unsigned int)N; k += step) {
        seen = (unsigned int)(seen + !flags[k]);
        flags[k] = 1;
    }
    return seen;
}

/* Same shape at width 2, so the indexed access is a word store rather than a
   byte one (different address-add lowering, same DE-liveness question). */
static unsigned int word_walk(unsigned int start, unsigned int step)
{
    unsigned int k, sum = 0;

    for (k = start; k < (unsigned int)WN; k += step) {
        sum = (unsigned int)(sum + words[k]);
        words[k] = (unsigned int)(k + 1u);
    }
    return sum;
}

/* The index read back AFTER the indexed store, explicitly — the residue in DE
   is the thing under test, so consume it. */
static unsigned int last_index(unsigned int start, unsigned int step)
{
    unsigned int k, last = 0;

    for (k = start; k < (unsigned int)N; k += step) {
        flags[k] = 2;
        last = k;              /* reads k after the store through &flags[k] */
    }
    return last;
}

/* NB the clear loops live in their own functions: written inline in
   test_addridx they trip a SEPARATE, pre-existing fp-mode abort ("value read
   with no live register and no stack slot", v0 phys BC) that reproduces on
   master and has nothing to do with #ADDR. */
static void clear_flags(void)
{
    int i;
    for (i = 0; i < N; i++) flags[i] = 0;
}

static void clear_words(void)
{
    int i;
    for (i = 0; i < WN; i++) words[i] = 0;
}

static void test_addridx(void)
{
    assertEqual(main_count, 1007);      /* the in-main sieve: primes in [2,7999] */

    clear_flags();
    assertEqual(sieve_like(), 1007);

    clear_flags();
    /* 0,2,..,7998 -> 4000 marks, all previously clear */
    assertEqual(mark_walk(0, 2), 4000);
    /* same walk again: every one already set, so none counted */
    assertEqual(mark_walk(0, 2), 0);
    /* odd positions are still clear: 1,3,..,7999 -> 4000 */
    assertEqual(mark_walk(1, 2), 4000);

    clear_flags();
    /* step 7 from 3: 3,10,..,7999 -> 1143 marks */
    assertEqual(mark_walk(3, 7), 1143);
    /* start beyond the bound: loop body never runs */
    assertEqual(mark_walk(N, 1), 0);

    clear_words();
    /* first pass sums zeroes and writes k+1 */
    assertEqual(word_walk(0, 16), 0);
    /* second pass sums 1 + 17 + 33 + 49 = 100 */
    assertEqual(word_walk(0, 16), 100);   /* WN=64: 0,16,32,48 */

    /* 5,12,19,...  -> last below 8000 is 7999 */
    assertEqual(last_index(5, 7), 7999);
    assertEqual(last_index(63, 4), 7999);
}

static unsigned int main_count;

int main(int argc, char *argv[])
{
    /* The sieve loop inlined into main, matching sieve/z88dk-classic exactly:
       in a leaf function the index stays at TOS and the LDSI+LHLX load never
       happens. */
    {
        unsigned int i, i_sq, k, count;
        int j;
        for (j = 0; j < N; j++) flags[j] = 0;
        count = (unsigned int)(N - 2);
        i_sq  = 4;
        for (i = 2; i_sq < (unsigned int)N; ++i) {
            if (!flags[i]) {
                for (k = i_sq; k < (unsigned int)N; k += i) {
                    count -= !flags[k];
                    flags[k] = 1;
                }
            }
            i_sq = (unsigned int)(i_sq + i + i + 1u);
        }
        main_count = count;
    }
    (void)argc; (void)argv;
    suite_setup("Symbol-address add with a live index");
    suite_add_test(test_addridx);
    return suite_run();
}
