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
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Call-bounded live-range splitting");
    suite_add_test(test_callsplit);
    return suite_run();
}
