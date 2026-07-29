# ADR 0017 — Ranged residency: a home-per-interval table as the single source of truth

Status: Accepted (implementation staged — see RESIDENCY_REDESIGN_PLAN.md)

Amends ADR 0003 (region-home-or-slot). Builds on ADR 0002 (register model),
ADR 0004 (soundness/gating) and ADR 0016 (two-pass lowering/carry).

## Context

ADR 0003 closes by noting the long-term consolidation — "one live-range allocator
subsuming the region pickers" — is desirable but a rewrite of default-on codegen, to be
done "incrementally, if at all." A source-level survey (RESIDENCY_SURVEY.md) and a design
grilling made the case concrete and committed to a shape. Two problems drive it:

1. **Correctness.** Every documented residency miscompile class shares one root: residency
   is *decided* by the allocator, then independently *re-derived* by the lowerer at render
   time (`compute_home_region` + the `bb_byte_out` cross-BB carry). Two reasonings about the
   same fact drift apart (stale carries, dirty-flag loss, no-slot eviction).
2. **Capability.** The scarce register file (ADR 0002) means residency is the dominant
   optimisation, but the model is coarse: 9 of ~12 mechanisms give one home per vreg for a
   whole region. Trailing benches spill loop-carried words to the stack because a value can
   only be all-in-a-register-for-its-region or all-in-a-slot.

The destination is **ranged residency** (a value resident over the sub-range it is actually
live; a register time-shared by disjoint values). The prerequisite is a **single source of
truth**: ranged is unsafe to bolt onto a re-deriving lowerer — it would multiply exactly
the interaction that causes today's miscompiles. So SSoT is built first, deliberately, as
the foundation ranged stands on.

## Decision

Move from region-home-or-slot to a **home-per-interval table** that the allocator produces
and the lowerer reads.

- **Representation.** The allocator's output is a table queried as `home_at(v, op_index)` —
  which register holds a value over which `[lo,hi]` interval, slot elsewhere. A single-home
  vreg is the degenerate one-interval case. This is the structure ranged needs; it is
  populated equivalently at first so the change is byte-identical, not a throwaway.
- **Two-tier registers (ADR 0002).** *Bus* = HL, A — the lowerer's fixed codegen ports,
  never homes. *Parking* = DE, BC, IX, IY (+ halves, alt-bank, stack) — the allocatable
  homes. The allocator places long-lived values into parking registers in the gaps the
  fixed codegen leaves alone. It is not a scratch free-list; the lowerer never asks for a
  register.
- **Consolidate, do not rewrite.** The ~12 proposers keep their z80-specific heuristics
  (counter-hostility, DE-cleanliness, single-BB byte safety, the cost model) but are
  refactored to consume one liveness substrate, share one interference relation, and emit
  interval-homes into the table. We adopt linear-scan's interference discipline, not its
  uniform-cost blindness. No flag-day linear-scan replacement.
- **Allocator owns the cleanliness proof.** The `op_de_clean` / `home_span_valid` /
  natural-loop / exit-flush reasoning moves to alloc-time: a home-interval is admitted only
  if every op in its span is clean w.r.t. that register. The lowerer stops running
  `compute_home_region`.
- **Lowerer diffs the table; no IR mutation.** Transitions (load at an interval start,
  spill/release at the end, move across a BB edge) are emitted by the lowerer comparing
  `home_at` across the boundary — not by the allocator inserting transition ops (which would
  re-index the IR and invalidate its own analysis). Genuine parallel-copy cycles at an edge
  are the only possible exception (vanishing on a 4-parking-register file).

### Invariants (the alloc↔lower contract)

- **I1 — single source of truth for homes.** Home residency at any point is `home_at`; the
  lowerer reads it, never re-derives it.
- **I2 — effect soundness.** An op clobbers exactly `op_clobbers(f,op)`; no live vreg's home
  interval is clobbered inside that interval except by a table-directed move.
- **I3 — one liveness.** All liveness/interval/interference queries go through the shared
  substrate (`LiveRange`, `live_in_per_op`, `ir_live_ranges_overlap`). No proposer rolls its
  own.
- **I4 — cross-BB by construction.** A home interval spanning a BB edge means the value stays
  in the register across it; a shuffle is realised only where adjacent intervals disagree,
  replacing the "all preds agree" carry for homes.
- **I5 — bus tenancy is lowerer-local and retained.** The belief cache for the bus (HL, A),
  including the `bb_hl_out` / `bb_a_out` carries, stays as an independent reload-avoidance
  optimisation. SSoT governs *homes*, not bus tenancy. Only `bb_byte_out` (a home carry) is
  subsumed by the table; the bus carries survive.

### Soundness net (ADR 0004)

`IR_VERIFY` gains a second layer. The existing op-level check (emitted writes ⊆
`op_clobbers`, i.e. the model over-approximates reality) is necessary but does **not** catch
an over-admitted interval: an unclean op's clobber is *within* its own `op_clobbers`, so the
op-level check passes while the home is corrupted. The new **interval-level check** encodes
I2 directly: for each op, `op_clobbers(op)` must not intersect the home register of any vreg
whose interval spans this op (excluding the value defined/moved here). This is what makes
allocator-owned proof safe.

## Consequences

- **The miscompile classes die by construction** once the proof is at alloc-time and the
  carry *is* the interval (the cross-BB carry / dirty-flag / no-slot-eviction classes).
- **Risk concentrates in the allocator.** Cleanliness is reasoned about in exactly one
  place, so an over-admitted interval is a miscompile — mitigated by the interval-level
  `IR_VERIFY` check, not by a belt-and-braces lowerer re-check.
- **What is retired**: the ~4 duplicate liveness scans; the three interference models
  collapsed to one; `compute_home_region` / `home_span_valid` (moved to alloc-time);
  `bb_byte_out` (subsumed); eventually the `lra_line_writes` asm-text parser (effects become
  declared in the table, not parsed from asm).
- **What is retained**: `op_clobbers`/`op_clobbers_relaxed`; the cost model; spill slots;
  the emit primitives; **bus reload-avoidance untouched** (`rs.hl`/`rs.a`, `bb_hl_out`,
  `bb_a_out`).
- **Out of scope**: float/i64 accumulators (FA/`__i64_acc`); the param-in-place and
  cacheable-HL pre-passes; calling convention and slot layout.
- **Staged and byte-identical-gated (ADR 0004).** SSoT lands first (steps that are
  byte-identical or a proven fix), then ranged capability (measured, gated). Ship after each
  sub-step; if a step neither simplifies (mechanisms/carries retired) nor unlocks (bench
  gaps), stop. The migration lives in RESIDENCY_REDESIGN_PLAN.md; this ADR records the
  durable direction and contract.
