# ADR 0025 — Post-render code layout: merge, then lay out, then relax

Status: Accepted (2026-09)

Amends ADR 0013 (the peephole / assembly-text layer), which describes the text
layer but not the three layout transforms that now run in it.

## Context

Three size optimisations operate on the rendered assembly text rather than on
the IR, because each needs the final instruction sequence: identical tails only
become visible after peepholes, block placement only matters once jumps are
real, and a jump's displacement is only known once everything before it is
sized.

## Decision

Run them as an ordered pipeline in the text layer. The order is load-bearing and
must not be rearranged:

1. **Tail merging.** Where several paths end in the same instruction run, keep
   one copy and turn the others into a jump to it. Per function only, and the
   shared terminator must be **unconditional** — replacing a conditional tail
   would redirect its fall-through, which the sites do not share. This is a
   byte-for-cycle trade: the bytes are saved once, the jump's cycles are paid on
   every execution. ADR 0019 records why this stays within one function.
2. **Block layout.** Move a trace to follow its predecessor so a jump
   disappears. A trace may move only if its labels have exactly one reference
   between them, nothing falls through into them, and it ends in an
   unconditional terminator — otherwise the moved code loses an entry or runs
   off its end. A trace head can carry several labels at one address (tail
   merging puts its label directly under the block's), so references are summed
   over all of them and the labels travel together.
3. **Branch relaxation.** Re-size `jp` to `jr` where the displacement fits.

The ordering follows from what each stage consumes: block layout can move the
labels and jumps that tail merging created, and relaxation must run last because
both earlier stages change the displacements it measures.

Relaxation of *conditional* branches is universal, because the not-taken path
pays for the taken path's extra cycles. Relaxation of *unconditional* jumps is
per CPU: it is a win where `jr` is no slower than `jp` (gbz80, ez80, kc160,
rabbit, z180) and a loss on plain z80, where it costs cycles in loops.

Each stage is disable-only through the one opt-out registry: `tail-merge`,
`block-layout`, `jr-relax`.

## Consequences

A transform in this layer sees no IR and cannot consult liveness, so its
conditions are textual and must be conservative. Both merging and layout have a
rule that miscompiles if broken, recorded above and enforced in code; each has a
regression test under `test/suites/long_ir`.
