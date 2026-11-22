# ADR 0022 — Widening the long stack-park pass

Status: Rejected (2026-09-11)

Relates to ADR 0009 (wide-value accumulator) and ADR 0016 (two-pass lowering).

## Context

A chained long operation parks its operand on the data stack (`push de; push hl`)
instead of in a frame slot, and the consumer pops the halves back. The pass is
gated on `use_count[dst] == 1`, labelled "MVP — conservative". A census suggested
several hundred sites were being turned away by that gate, which made widening
it look like the largest single win available.

## Decision

Do not widen the pass by lifting the single-use condition.

The census was wrong, and how it was wrong is the durable part: it tested its
gates as an `if/else` chain with the use-count test **first**, so that bucket
absorbed every site that also failed another gate. Re-testing the rejects
against the gates a widened pass would genuinely need leaves **zero** eligible
sites across the whole corpus, clisp and emu.c.

The larger finding is about the condition itself. **The IR is not SSA.**
`use_count` is function-wide and pools the uses of every definition of a vreg,
and the first-use index within a basic block can precede the definition under
consideration when that vreg is redefined. `use_count[dst] == 1` is therefore
not a conservative use-count heuristic at all — it is doing duty as a
**def-uniqueness** gate, and it is what makes def/use pairing sound without a
reaching-definitions analysis. Lifting it does not relax a heuristic; it removes
the property keeping the pass correct.

The apparent population was also an artifact: one benchmark's ~197 sites are
four distinct vregs redefined about 48 times each across unrolled rounds, and
reported once per definition.

## Reopening

Only behind real reaching-definition liveness, not by relaxing the gate. Even
then the only shape it reaches is the one benchmark 80cc already wins
decisively, so the upside is in a file that is not the problem.
