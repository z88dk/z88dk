/* Call-bounded live-range splitting (IR_CALLSPLIT): a spilled reused word value
 * made BC-resident inside a call-free span with >=3 reads, spilled (slot-homed)
 * across the calls it crosses.
 *
 * Pins CORRECTNESS of the split boundaries: the entry reload (BC := slot after a
 * call), the read-only case (slot stays coherent), and the WRITE-BOTH case (an
 * in-span def writes both the slot and BC so a later out-of-span read / next
 * iteration reads the current value across the call). A missed reload or an
 * un-invalidated stale BC belief miscompiles the checksum.
 *
 * churn_readonly reliably FIRES the split here (base is BC-resident in the
 * call-free span). churn_written is a written-accumulator-across-calls
 * correctness case: whether its seed wins the split depends on BC availability
 * (a short-lived temp often contends for BC in a minimal function), so it guards
 * correctness whether or not it splits. The WRITE-BOTH codegen itself is
 * exercised in the bench corpus by searchbench/maskbench/matrixbench/strbench.
 *
 * Self-verifying (host-independent constants). Runs on z80 sp/fp plus 8080/gbz80
 * (byte-wise `ld bc,hl` + slot store). A real call (sink) inside each loop forces
 * the call boundary and the cross-call spill; NO printf (would perturb allocation
 * and mask the bug, like the enigma family). */
#include "test.h"
#include <string.h>

static unsigned int g_acc;
/* Opaque-enough callee: clobbers the caller-saved regs (BC/DE/HL) so the split
 * value genuinely cannot ride a register across it. Kept trivial + side-effecting
 * (writes a global) so it is a real IR_CALL, not inlined away. */
static void sink(unsigned int x) { g_acc += x; }

/* WRITE-BOTH: seed is read (>=3x in the s*25173 shift-add) AND written each
 * iteration, and lives across sink() in its slot. chk is a global (kept out of a
 * register) so BC is free for seed's write-both split. */
static unsigned int g_chk;
static unsigned int churn_written(int n)
{
    unsigned int seed = 0xACE1u;
    int i;
    g_chk = 0;
    for (i = 0; i < n; i++) {
        seed = (unsigned int)((seed + 13849u) & 0xffffu);      /* WRITE — mid-span */
        g_chk = (unsigned int)((g_chk + seed) & 0xffffu);      /* read NEW seed */
        g_chk = (unsigned int)((g_chk + (seed >> 8)) & 0xffffu);   /* read */
        g_chk = (unsigned int)((g_chk ^ seed) & 0xffffu);      /* read */
        sink(seed);                                            /* read + call: cross */
    }
    return g_chk;
}

/* READ-ONLY-in-span: base is defined once before the loop, read >=3x in the
 * call-free span each iteration, never written in-span; lives across sink(). */
static unsigned int churn_readonly(int n)
{
    unsigned int base = 0x1234u, chk = 0;
    int i;
    for (i = 0; i < n; i++) {
        chk = (unsigned int)((chk + (base & 0xffu) + (base >> 5)
                              + (base ^ 0x0f0fu) + (base + (unsigned int)i))
                             & 0xffffu);                             /* 4 reads */
        sink(chk);                                                   /* call: cross */
    }
    return chk;
}

/* FLAT-INVERTED INNER LOOP: a loop-carried word (isq) is BC-homed by the split
 * over the outer body, but its update block is emitted in op order BEFORE the
 * NESTED inner loop that marks the byte array — so the inner loop sits at flat
 * indices past the split's span while running control-flow between the split's
 * uses. The inner `fl[k]=1` store takes a BC temp for its address and clobbers
 * the carried isq every iteration. The bc_busy interference check used flat
 * op-index overlap, which missed this; the split coexisted with the inner temp
 * in BC. Only bites CPUs with no index-register home for isq (8080/8085/gbz80 —
 * z80/z180/z80n park it in IY); pre-fix returned 50, not 25. A small Sieve of
 * Eratosthenes is the minimal shape (nested loop + strided byte store + a call,
 * memset, to trigger the split). Host-verified: 25 primes in [2,99]. */
static unsigned char fl[100];
static unsigned int primes_nested(void)
{
    unsigned int i, isq, k, count;
    memset(fl, 0, sizeof fl);
    count = 100 - 2;
    isq = 4;
    for (i = 2; isq < 100; ++i) {
        if (!fl[i])
            for (k = isq; k < 100; k += i) { count -= !fl[k]; fl[k] = 1; }
        isq += i + i + 1;                       /* isq carried across the k-loop */
    }
    return count;
}

/* Statement-context boolean compound updates: both directions must preserve
 * their independent results when lowered as conditional pre-steps. */
static unsigned int bool_steps(void)
{
    unsigned char b[6] = { 0, 1, 0, 1, 0, 1 };
    unsigned int plus = 0, minus = 6, i;
    for (i = 0; i < 6; ++i) {
        plus  += !b[i];
        minus -= !b[i];
    }
    return (plus << 8) | minus;
}

/* A long expression result must survive the recursive call while its argument
 * is built.  This is the IR form that used to spill the left operand to a
 * frame slot on SP-mode targets, even though it can be parked below the call's
 * arguments with the same stack-preservation operation used in FP mode. */
static long recursive_long_add(long x, unsigned int n)
{
    long base = x + 3;
    if (n == 0) return base;
    return base + recursive_long_add(x + 1, n - 1);
}

/* Consecutive fixed-offset stores through one heap pointer must retain their
 * source order while the lowerer walks the destination address. */
typedef struct {
    unsigned int left, right;
    long item;
} chain_node;

static long chain_stores(unsigned int left, unsigned int right, long item)
{
    chain_node node;
    chain_node *p = &node;
    long result;
    p->left = left;
    p->right = right;
    p->item = item;
    result = (long)p->left + (long)p->right + p->item;
    return result;
}

/* A constant pointer displacement should be folded into the dereference, even
 * on CPUs without indexed addressing.  This keeps the address as one IR_MEM
 * base+offset operation instead of materialising q and then loading through q.
 */
static unsigned int deref_offset_loads(const unsigned int *p)
{
    const unsigned int *q = p + 1;
    return q[0] + q[1];
}

static void test_callsplit(void)
{
    g_acc = 0;
    /* Explicit constants (host-computed with the identical 16-bit arithmetic) so a
     * miscompile — a missed reload / stale BC belief / lost write-both store —
     * fails the assert instead of matching a consistently-wrong self-comparison. */
    assertEqual(churn_written(0),  0u);        /* 0-trip: seed init untouched */
    assertEqual(churn_written(1),  294u);
    assertEqual(churn_written(8),  32335u);
    assertEqual(churn_written(20), 56814u);

    assertEqual(churn_readonly(0),  0u);
    assertEqual(churn_readonly(10), 57909u);

    assertEqual(primes_nested(), 25u);         /* flat-inverted inner-loop BC clobber */
    assertEqual(bool_steps(), 0x0303u);        /* +=/-= !cond both fire */
    assertEqual(recursive_long_add(5, 3), 38L); /* long survives recursive call */
    assertEqual(chain_stores(3, 4, 5), 12L);   /* aggregate store chain */
    {
        static const unsigned int data[3] = { 7u, 11u, 13u };
        assertEqual(deref_offset_loads(data), 24u);
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Call-bounded live-range splitting");
    suite_add_test(test_callsplit);
    return suite_run();
}
