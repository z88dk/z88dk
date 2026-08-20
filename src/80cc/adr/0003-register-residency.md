# ADR 0003 — Register residency: region homes, the orchestrator, and live-range packing

Status: Accepted

## Context

The scarce, constrained register file (ADR 0002) makes *keeping hot values in
registers* the dominant back-end optimisation. 80cc's residency machinery grew
in two eras, and both are still live. This ADR describes what each does and how
they compose, so the whole is legible.

## Decision

Residency is **region-home-or-slot** with two cooperating mechanisms, plus a
peephole cache underneath.

### 1. Region homes — the proposer/arbiter orchestrator (`ir_alloc.c`)

A value can win a **dedicated register for a whole loop region**. Each residency
class has a *proposer* that emits `Cand`idates with a depth-weighted benefit:

- `pr_bc_propose` — a loop pointer/IV in BC.
- `word_acc_propose` — a loop-carried word accumulator in DE (`add hl,de; ex de,hl`).
- `de_home_general_propose` — a general loop-carried word in DE.
- `iv_propose` — an induction variable.
- `byte_home_propose` — a char accumulator in a byte half (C/B/E/D).
- `idx2_propose` / `idx3_propose` — a loop-invariant / second word in the spare
  index register(s) (IX/IY opposite the frame pointer), opt-in.
- `exx_propose` — a loop-invariant in the alt/shadow bank, opt-in.

`unified_arbitrate` picks winners by benefit over **whole-function / loop-extended
intervals** — i.e. one occupant per register per region. That coarseness is
deliberate in places (a loop-carried tenant blocks its whole loop; the extension
guards a real correctness case).

### 2. Live-range packing — the fine passes

Run *after* the arbiter, over the SPILL leftovers, using **tight per-op
intervals** so several disjoint values can time-share one register:

- `ir_bc_pack` — packs disjoint call-free word temps into BC (greedy interval
  scheduling); "multiple BC use within a function".
- `ir_iy_reduction_pack` — homes a DE-dirty reduction chain / loop-carried
  accumulator in **IY** (`add iy,de`), the one pair immune to HL+DE staging;
  includes benefit-ranked arbitration to evict a lower-value idx2 occupant.
  Gated `IR_LRA`.
- `ir_stack_spill` — parks a single-def/single-use straight-line transient on the
  **stack** (`push hl` … `pop`) instead of a frame slot.

The two fine passes that share the *single-BB tight-interval shape* analysis
consume one `compute_spill_shapes()` (see the SpillShape struct); each keeps only
its own placement policy.

### 3. The peephole value cache (`ir_lower_regcache.inc.c`)

Underneath both, `L.rs.{hl,de,bc,a}` remembers what a register currently holds so
an immediately-following op can reuse it without a reload. It is evicted as soon
as the next op loads its operands — a local optimisation, not residency.

## Consequences

- A value that wins no region home and no pack becomes a **slot vreg**: every use
  is load→compute→store, saved only by the peephole cache. In a spill-bound inner
  loop this thrashes — the motivation for the live-range packing era.
- The **generalising direction is shorter ranges, not bigger regions.** Attempts
  to hold *more* values for a whole region (wider DE reservation, cross-row
  pointers) repeatedly hit the register-file ceiling; giving a value a register
  for just the span it is live (BC-pack, IY reduction) fits by construction.
- **DE cannot be a persistent second home** in general: the operand loader owns
  DE for staging the second ALU operand, so almost every spill span crosses a
  DE-clobbering op. IY is the workaround (immune to staging). This is a
  fundamental z80 wall, not a missing feature — see ADR 0002.
- The long-term consolidation (one live-range allocator subsuming the region
  pickers) is desirable for maintainability but is a rewrite of default-on
  codegen under a byte-identical constraint (ADR 0004); do it incrementally, if
  at all. The fine passes already share their analysis.
