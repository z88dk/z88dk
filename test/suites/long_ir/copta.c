/* A copt fold must not delete a LIVE definition of A.
 *
 * `ld a,(_g); ld l,a; ld h,0` (a byte read of a global, widened to int) was
 * folded to `ld hl,(_g); ld h,0` for one byte, on the claim that "A is left
 * untouched". The opposite is true: the fold removes the only instruction that
 * PUT the byte in A. HL is right, A now holds whatever it held before, and the
 * NEXT reader of that byte gets garbage. copt is a text peephole with no
 * liveness, so it cannot tell a dead A from a live one — the rule is deleted.
 *
 * WHAT IT TAKES TO BITE. 80cc must read the global's byte ONCE and widen it
 * TWICE, leaving A live between the two widens. That needs:
 *   - a GLOBAL (or array element) source. A local or a parameter is not hit.
 *   - the result widened back to int. A `unsigned char` destination is fine.
 *   - two narrowing conversions that are STRUCTURALLY DIFFERENT. Two identical
 *     ones are safe only because CSE folds them to a single computation, which
 *     is why two plain `(unsigned char)W` reads look correct and hid this.
 *
 * The failure is SILENT and costs no bytes anywhere in the corpus, so nothing
 * but a value check finds it: the whole bench corpus (30 benches x 11 CPUs x 2
 * frame modes) is byte-identical without the rule.
 *
 * THE FOLD ITSELF IS FINE — it just needs liveness, which copt does not have.
 * It now lives in ir_lower's post-render sweep as `gwiden`
 * (gw_fold_byte_global_widens), where A-liveness is a fact rather than a guess.
 * So this file gates BOTH directions at once, and both halves are load-bearing:
 *   - MUST NOT FIRE where A is live: two_narrowings() etc. Break the liveness
 *     guard (make gw_a_dead_after return 1) and this fails at the first assert.
 *   - MUST STILL FIRE where A is dead: array_elem() folds `ld a,(_A2+2); ld l,a`
 *     to `ld hl,(_A2+2)`, so the asm genuinely differs with IR_GWIDEN=0 and this
 *     file is not decoration for the positive path either.
 */
#include "test.h"

static unsigned int  W = 0xBEEFu;
static unsigned char B = 0x5Au;
static unsigned int  A2[3] = { 0x1234u, 0x5678u, 0x9ABCu };

/* The original report. The inner `(unsigned int)` cast makes the two
   narrowings structurally different, so CSE keeps both — and both are served
   from one `ld a,(_W)`. `b` came back 0. */
static unsigned int two_narrowings(void)
{
    unsigned int a = (unsigned char)(unsigned int)W;
    unsigned int b = (unsigned char)W;
    return (unsigned int)(a + b);                 /* 239 + 239 = 478 */
}

/* Same shape reached through a mask rather than a second cast. */
static unsigned int cast_and_mask(void)
{
    unsigned int a = (unsigned char)W;
    unsigned int b = (unsigned int)(W & 0x00ffu);
    return (unsigned int)(a + b);                 /* 478 */
}

/* An array element is a global address too. */
static unsigned int array_elem(void)
{
    unsigned int a = (unsigned char)(unsigned int)A2[1];
    unsigned int b = (unsigned char)A2[1];
    return (unsigned int)(a + b);                 /* 0x78 + 0x78 = 240 */
}

/* A byte global widened twice: the fold's `ld hl,(_B)` would also read the
   byte AFTER B, so this pins the value as well as the A liveness. */
static unsigned int byte_global_twice(void)
{
    unsigned int a = (unsigned char)(unsigned int)B;
    unsigned int b = (unsigned char)B;
    return (unsigned int)(a + b);                 /* 90 + 90 = 180 */
}

/* The single-widen control: correct even with the rule present, so a pass here
   proves nothing on its own — it pins that the deletion did not break the
   ordinary case. */
static unsigned int single_widen(void)
{
    return (unsigned int)(unsigned char)W;        /* 239 */
}

static void test_copta(void)
{
    assertEqual(two_narrowings(), 478u);
    assertEqual(cast_and_mask(), 478u);
    assertEqual(array_elem(), 240u);
    assertEqual(byte_global_twice(), 180u);
    assertEqual(single_widen(), 239u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("copt must not delete a live A");
    suite_add_test(test_copta);
    return suite_run();
}
