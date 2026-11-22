# ADR 0101 — the idx2 slot can host non-overlapping live ranges

Status: **Accepted**, default on. `idx2-reuse` opts out.

## Context

`f->idx2_reg` (the spare index register, IX or IY in sp-mode) was a single
whole-function owner: `idx2_taken` in `unified_arbitrate` (`ir_alloc.c`) was a
plain boolean, so the first RC_IDX2 candidate accepted blocked every later
one for the rest of the function, regardless of whether their live ranges
ever actually overlapped.

Found while validating ADR 0102 (the IVSR induction pointer): `interpbench`'s
`vm_run` has two sibling loops at the same syntactic depth, and the theory
was that both wanted idx2 and the wrong one won. That theory did not survive
contact with the actual build — see ADR 0102's regression note — but the
underlying allocator limit is real and worth fixing on its own.

## Decision

`idx2_taken` becomes `Idx2Live`, a small list of accepted occupants' vreg and
`[first_use, last_use]`. A new RC_IDX2/RC_IDX3 candidate is accepted whenever
its interval doesn't overlap any already-accepted occupant (`iv_overlap`, the
same interference test the pre-existing BC multi-occupant class already
uses). The moment a genuine second occupant joins the slot, every occupant's
realized home (`home_lo`/`home_hi`) is pinned to its own verified interval.
This matters because a later pass (`tight-homes`) clamps a home to the
vreg's TRUE live range (`ir_live_range`), which can start earlier than the
candidate's `first_use` — left alone, that clamp could widen one occupant's
realized window back into a window another occupant now also owns. Pinning
a floor here is safe because `tight-homes` only ever narrows, never widens
past an existing floor; a function with only one occupant never runs this
block, so its home stays untouched (the prior behaviour, exactly).

`--opt-disable=idx2-reuse` / `IR_OFF=idx2-reuse`: the first acceptance forces
every later query to fail, structurally reproducing the old single-owner
behaviour (not just measured byte-identical — the gate-off path cannot reach
the new code at all after the first occupant).

## Why it measures zero

BC already has its own proven multi-occupant mechanism, and it ranks ABOVE
idx2 for ordinary candidates (cheaper to fill, no callee-save cost). So
whenever two candidates for different vregs truly have disjoint windows,
BC's existing interference check claims them first, before the arbiter's
loop ever reaches their idx2 proposals. Confirmed directly: a constructed
two-disjoint-loops test (two back-to-back array-sum loops) produces exactly
the disjoint-interval pair this ADR targets, and both land on BC via the
pre-existing mechanism, never idx2.

The only candidates with no BC alternative are `CF_IDX2_INDUCTION` walking
pointers (ADR 0102, ez80/kc160/rabbit only) — and in every sampled function,
including `vm_run`, IVSR only ever proposes ONE such candidate per function.
So there is currently no real function in the corpus where a second,
non-overlapping idx2-only candidate exists to share with. The capability is
kept anyway: it is proven safe, costs nothing where it doesn't fire, and
stands ready for whatever real file or future bench does produce the shape.

## Regression coverage

`long_ir/idx2reuse.c` (9 targets, default CPU + ez80, 8080, gbz80): a
non-overlapping param/counter pair (exercises acceptance), and a genuinely
overlapping pair (exercises that the overlap test still correctly denies
sharing — sharing one register between two truly-live values would corrupt
one of them, so wrong output here means the overlap test regressed, not an
allocation-quality question).

## Evidence

`long_ir` 518/518 files, 926/926 runs, both frame modes, 0 failures.
`enigma` and the magnetic-emulator behavioural gate pass both modes. A
compile-only on/off asm diff across all 29 corpus benches, all 13 CPUs, both
frame modes (682 cells) is byte-identical in every cell, including
`interpbench`/ez80.
