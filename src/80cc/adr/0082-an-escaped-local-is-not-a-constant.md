# ADR 0082 — An address-escaped local is not a constant

Status: **Accepted**. A correctness fix, so it is **not gated**.

## Context

`ir_opt_const_fold` tracked each vreg's constant value in a per-basic-block
`known[]` table and cleared an entry only when the vreg was **redefined**.
Nothing cleared it when memory could be written behind the pass's back, and a
local whose address escapes to a call is exactly that case:

```c
static void bump(unsigned int *q) { *q += 1u; }

unsigned int c_init(unsigned int x)
{
    unsigned int a = 0;
    bump(&a);
    return a + x;        /* folded to `x` — WRONG */
}
```

`a = 0` set `known[a]`, the `IR_LEA` + call did not clear it, and `a + x` hit
the `0 + x -> x` rule. **80cc returned `x`; gcc and sccz80 both return
`a + x`.** Wrong in both frame modes, on every CPU, silently — a plausible
number, not a crash.

How it was found is worth recording: the shape was written as a *codegen* test
for ADR 0081's `lea` rung, and it failed for a reason that had nothing to do
with the rung. The pre-sweep baseline compiler (`b6a8b1a3`) reproduces it, so
it is long-standing, and `--opt-disable=all` was what first localised it —
then a sweep of the registry named `const-fold` exactly.

Two shapes that were always right, and they explain why it went unnoticed: a
**non-constant** initialiser (`unsigned int a = g;`) was never tracked, so
there was no stale belief to use; and `return a` with no arithmetic reads the
slot, because the fold rewrites *operations*, not loads.

## Decision

An `IR_VREG_ADDR_TAKEN` vreg is never entered into `known[]`.

The alternative — keep tracking, and clear the escaped entries at every call —
is more precise and was rejected for now: it has to enumerate every op that can
write through an escaped pointer (calls, but also an indirect store whose base
could be that address), and getting that list wrong reintroduces a silent wrong
answer. `IR_VREG_ADDR_TAKEN` already means "must spill", so the value lives in
a frame slot regardless and the folding given up is worth little.

Folding where nothing escapes is untouched, which is the half a blunter fix
would have broken.

## Consequences

* the reproducer and its family now agree with gcc and sccz80 in both frame
  modes
* `long_ir` all-pass in both frame modes; corpus and behavioural gates green
* the size cost is small and is recorded with the day's other figures in
  `BENCH_MATRIX.txt`

Regression test `test/suites/long_ir/cfescape.c`, seven targets across z80 in
both frame modes, 8080, gbz80, 8085, r4k and ez80. It pins the bug (`c_init`,
`c_twice`), both shapes that always worked (`v_init`, `c_plain`) so a future
change cannot quietly stop tracking constants altogether, and one function
where folding **must still happen** (`c_fold`) — pinned by value, not by
reading the asm.

**The same hole may exist in other passes.** This one was found because
`const-fold` had a reproducer; nothing has been checked for AST-level
propagation (`prop`), CSE, or the lowerer's register beliefs, and the search
term is the same: a belief about a local's value that is invalidated only by a
redefinition. `ast_opt`'s DSE already models escape properly (`dse_collect_escaped`),
which is the shape to copy.
