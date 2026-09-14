# 80cc Architecture Decision Records

These ADRs describe **how the 80cc back end works and why** — the durable design,
as distinct from the many `*_PLAN.md` files (which are transient, per-effort
working notes). Read these to understand the compiler; read the plans only for
the history of a specific optimisation.

80cc is one of z88dk's C compilers: a small-C front end feeding an SSA-ish
intermediate representation and a retargetable 8-bit back end (z80, z80n, z180,
ez80, rabbit, gbz80, 8080, 8085, kc160).

| ADR | Topic |
|-----|-------|
| [0001](0001-ir-backend-pipeline.md) | IR-based back end and the compilation pipeline |
| [0002](0002-z80-register-model.md) | The z80 register reality and the vreg → physical-register model |
| [0003](0003-register-residency.md) | Register residency: region-home-or-slot, the orchestrator, and live-range packing |
| [0004](0004-soundness-and-gating.md) | Soundness: `op_clobbers`, `IR_VERIFY`, revert-to-slot, `require_slot`, and byte-identical gating |
| [0005](0005-helper-clobber-table.md) | The runtime-helper clobber table (`__preserve_regs`) |
| [0006](0006-multi-cpu-retargeting.md) | Multi-CPU retargeting (CPU-agnostic pipeline; CPU knowledge in the lowerer) |
| [0007](0007-kind-width-type-model.md) | The type-kind / width model on VRegs |
| [0008](0008-ivsr-strength-reduction.md) | Induction-variable strength reduction (IVSR) and LFTR |
| [0009](0009-wide-value-accumulator.md) | Wide (6/8-byte) value handling via a memory accumulator (`__i64_acc` / FA) |
| [0010](0010-ast-vs-ir-optimisation-layering.md) | AST-level and IR-level optimisation: a deliberate two-level split |
| [0011](0011-index-register-allocation.md) | Index-register (IX/IY) allocation by frame mode, and reservation |
| [0012](0012-frame-pointer-default-by-cpu.md) | Per-CPU default for the frame pointer (fp on z80/z80n/z180/ez80) |
| [0017](0017-ranged-residency-ssot.md) | Ranged residency: a home-per-interval table as the single source of truth (amends 0003) |
| [0013](0013-peephole-text-layer.md) | The peephole / assembly-text layer: copt (80cc_rules.1 only) + the post-render text filter (dead-label elision, defc relocation, operand-rewrite jump threading) |
| [0014](0014-volatile-behaviour.md) | Volatile behaviour: VREG_VOLATILE locals, `mem.volatile_` derefs, the `;volatile` copt stamp |
| [0015](0015-ir-pattern-matcher.md) | The IR pattern-matcher engine: declarative production table (templates + check/apply + exclude_cpus), side conditions written once |
| [0016](0016-two-pass-lowering-and-carry.md) | Two-pass lowering: cross-BB register carry (bb_hl_out / byte-home), lazy spill (store-on-clobber), and rematerialisation |
| [0018](0018-operand-residency-de-cache.md) | **Rejected** — operand residency via a DE cache (both the single-BB cache and the cross-BB carry) |
| [0019](0019-cross-function-tail-merging.md) | **Rejected** — cross-function tail merging and shared epilogue helpers (banking) |
| [0020](0020-narrowing-a-pushed-argument.md) | **Rejected** — narrowing the producer of a byte-wide pushed argument |
| [0021](0021-per-value-spill-heuristics.md) | **Rejected** — per-value spill/placement heuristics (the decision is interference, not value kind) |
| [0022](0022-widening-the-long-stack-park.md) | **Rejected** — widening the long stack-park pass (its gate is def-uniqueness, not use count) |
| [0023](0023-bytewise-word-store.md) | **Rejected** — the bytewise word store (it must drop a belief the pair form keeps) |
| [0025](0025-post-render-code-layout.md) | Post-render code layout: tail merging, then block layout, then branch relaxation (amends 0013) |
| [0026](0026-index-home-as-addressing-mode.md) | The index home is an addressing mode, not only a value carrier (amends 0011) |
| [0027](0027-truthful-home-intervals.md) | *Proposed* — narrow each home to its true live range (first step of 0017) |
| [0028](0028-trip-count-weighting.md) | *Proposed* — weight costs by derived trip counts instead of `4^depth` |
| [0029](0029-de-cache-fold-brick.md) | *Proposed* — a fail-safe DE cache fold, where 0018 refuses a DE home |
| [0032](0032-gbz80-word-cost-row.md) | *Proposed* — the corrected gbz80 slot-cost row, blocked on a ranking tie |
| [0033](0033-relaxing-unconditional-jumps.md) | Relaxing unconditional jumps is per-CPU; `IR_JR_UNCOND` overrides it (amends 0025) |
| [0031](0031-stepped-pointer-param-in-bc.md) | A stepped pointer parameter may live in BC (promoted after the `frameless_ok` fix) |
| [0030](0030-debug-locals-in-frame-slots.md) | Under `-debug`, a named local is forced to a coherent frame slot (address-taken), with offsets emitted post-lowering |
| [0024](0024-byte-home-for-a-single-use-temp.md) | **Rejected** — relaxing the byte-home use-count gate (E is slot-backed; one byte home per function) |

Derived from the `*_PLAN.md` working notes: 0006 ← MULTICPU_IR, 0007 ← KIND_WIDTH,
0008 ← IVSR, 0009 ← the long-long/double accumulator design. Transient
per-optimisation plans (BC_PACK, PTRBENCH_*, the residency levers, MR_SQUASH,
REORG, the `*_BUG` post-mortems) stay as plans, not ADRs.

## Conventions

- **Status** of each ADR: Accepted / Superseded / Proposed / **Rejected**.
- A **Rejected** ADR records a lever that was measured and refused: what was
  tried, why it does not work, and what would have to change to reopen it. This
  is durable knowledge — it stops the same idea being rebuilt — but it is not a
  decision about how the compiler works, so it never changes the architecture
  the other ADRs describe. Keep it short, and link the evidence rather than
  quoting it.
- Performance figures live in commit messages, `BENCH_MATRIX.txt` and plan docs,
  **never in ADRs or code comments** (they go stale; the mechanism/rationale is
  what endures). This applies to a Rejected ADR too: state the conclusion, link
  the numbers.
- Each residency feature is gated so the compiler is **byte-identical with it
  off** — see ADR 0004. New residency work should preserve that property.
