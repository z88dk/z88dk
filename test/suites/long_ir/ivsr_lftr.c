/* IVSR linear-function-test-replacement bound handling (ir_opt_ivsr /
 * ivsr_try_lftr). A simple `for (i=0; i<n; i++) acc += arr[i]` over a global
 * array is strength-reduced to a walking pointer and its `i<n` exit test is
 * replaced by an unsigned pointer compare `p < p_end`, p_end built in the
 * pre-header.
 *
 * The bound guard: for a SIGNED variable bound n could be negative, and the
 * unsigned pointer compare would turn a 0-trip loop (n<=0) into a huge wrapped
 * one — so p_end clamps to base + max(0,n)*scale. For an UNSIGNED bound n>=0
 * always, so the clamp is dead and elided (the size win; regression for that).
 *
 * This pins CORRECTNESS of both paths, especially the two zero-trip edges the
 * guard exists for: unsigned n==0 (clamp elided) and signed n<0 (clamp kept).
 * Self-verifying: arr[i]=i+1 ⇒ sum of first n = n(n+1)/2. Both sp and fp. */
#include "test.h"

#define N 20
static unsigned int wu[N];
static int          wi[N];

/* Unsigned bound → LFTR elides the max(0,n) clamp (p_end = base + n*scale). */
static unsigned int usum(unsigned n)
{
    unsigned int s = 0, i;
    for (i = 0; i < n; i++)
        s = (s + wu[i]) & 0xffffu;
    return s;
}

/* Signed bound → the max(0,n) clamp is RETAINED (n may be negative). */
static int ssum(int n)
{
    int s = 0, i;
    for (i = 0; i < n; i++)
        s += wi[i];
    return s;
}

static void test_ivsr_lftr(void)
{
    int i;
    for (i = 0; i < N; i++) { wu[i] = (unsigned int)(i + 1); wi[i] = i + 1; }

    /* Unsigned bound — n==0 is the critical elided-clamp 0-trip edge. */
    assertEqual(usum(0),  0u);
    assertEqual(usum(1),  1u);
    assertEqual(usum(5),  15u);      /* 1+2+3+4+5 */
    assertEqual(usum(N),  210u);     /* 20*21/2 */

    /* Signed bound — n<0 is the wrap-guard 0-trip edge the clamp protects. */
    assertEqual(ssum(0),  0);
    assertEqual(ssum(5),  15);
    assertEqual(ssum(-3), 0);        /* MUST be 0 iterations, not a wrapped loop */
    assertEqual(ssum(N),  210);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("IVSR LFTR unsigned-bound clamp elision");
    suite_add_test(test_ivsr_lftr);
    return suite_run();
}
