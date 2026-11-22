/* Block layout (ir_lower.c, filter_block_layout): an unconditional jump whose
 * target block is entered ONLY by that jump is removed by moving the block's
 * trace under the jump.
 *
 * The three conditions this pins, each of which miscompiles if dropped:
 *
 *  - fallthru   a block that is ALSO reachable by falling through from the
 *               block laid before it must NOT be moved, or that path is lost.
 *               `refs == 1` alone does not prove single entry.
 *  - aliased    a trace head can carry SEVERAL labels on one address — tail
 *               merging emits `L_f*_tm_N:` directly under `L_f*_bb_M:`. The
 *               reference count must be summed over ALL of them and they must
 *               all travel with the code, or the aliases are left pointing at
 *               whatever now follows.
 *               >> THIS FILE DOES NOT CATCH THAT ONE. Verified against a
 *               compiler with the alias walk-back removed: this test still
 *               passed. What catches it is the emu.c behavioural gate, which
 *               drops from 385 output lines to 15. Run emu.c in BOTH frame
 *               modes on any change to this pass.
 *  - trace_end  the moved trace must end in an UNCONDITIONAL terminator, or
 *               control runs off the end of the moved code into whatever now
 *               follows it.
 *
 * The `fallthru` case IS proven to catch its own rule: with the fall-through
 * test removed from filter_block_layout, this file fails.
 *
 * The shapes are built with goto so the block order is explicit rather than
 * whatever the front end happens to emit. Self-verifying against constants
 * computed in the same 16-bit arithmetic.
 */
#include "test.h"

static unsigned int g_sink;
static void sink(unsigned int x) { g_sink = (unsigned int)(g_sink + x); }

/* A block reached only by a jump, laid after the fall-through path — the
 * movable shape. `cold` is entered solely from the goto. */
static unsigned int only_jump(unsigned int n)
{
    unsigned int acc = 0;
    if (n & 1u) goto cold;
    acc = (unsigned int)(acc + 1u);
    sink(acc);
    return acc;
cold:
    acc = (unsigned int)(acc + 100u);
    acc = (unsigned int)(acc ^ 0x55u);
    sink(acc);
    return acc;
}

/* A block reached BOTH by a jump and by falling through: `join` must stay put.
 * If it is moved under the goto, the fall-through path skips it. */
static unsigned int fallthru(unsigned int n)
{
    unsigned int acc = 0;
    if (n > 10u) goto join;
    acc = (unsigned int)(acc + 3u);      /* falls through into join */
join:
    acc = (unsigned int)(acc + 7u);
    sink(acc);
    return acc;
}

/* Several returns with the same tail, so tail merging puts an alias label on
 * the shared epilogue, and then a jump targets it — the aliased-head case. */
static unsigned int aliased(unsigned int a, unsigned int b)
{
    unsigned int t[4];
    t[0] = (unsigned int)(a + b);
    t[1] = (unsigned int)(a ^ b);
    t[2] = (unsigned int)(a * 3u);
    t[3] = (unsigned int)(b + 5u);
    if (a == 0u) { sink(t[0]); return (unsigned int)(t[0] + t[1]); }
    if (b == 0u) { sink(t[1]); return (unsigned int)(t[1] + t[2]); }
    if (a == b)  { sink(t[2]); return (unsigned int)(t[2] + t[3]); }
    sink(t[3]);
    return (unsigned int)(t[3] + t[0]);
}

/* A trace whose tail is a loop: the block ends in a BACK edge, not a ret, so
 * the trace end must be found correctly. */
static unsigned int trace_loop(unsigned int n)
{
    unsigned int acc = 0, i = 0;
    if (n == 0u) goto done;
loop:
    acc = (unsigned int)(acc + i);
    i++;
    if (i < n) goto loop;
done:
    acc = (unsigned int)(acc ^ 0x0fu);
    sink(acc);
    return acc;
}

static void test_blayout(void)
{
    g_sink = 0;

    assertEqual(only_jump(0), 1u);
    assertEqual(only_jump(1), 49u);
    assertEqual(only_jump(2), 1u);
    assertEqual(only_jump(3), 49u);

    assertEqual(fallthru(0),  10u);
    assertEqual(fallthru(11), 7u);
    assertEqual(fallthru(5),  10u);

    assertEqual(aliased(0, 4), 8u);
    assertEqual(aliased(4, 0), 16u);
    assertEqual(aliased(3, 3), 17u);
    assertEqual(aliased(9, 2), 18u);

    assertEqual(trace_loop(0), 15u);
    assertEqual(trace_loop(1), 15u);
    assertEqual(trace_loop(5), 5u);

    assertEqual(g_sink, 186u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Block layout (jump elimination by block move)");
    suite_add_test(test_blayout);
    return suite_run();
}
