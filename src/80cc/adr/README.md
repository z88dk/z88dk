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
| [0013](0013-peephole-text-layer.md) | The peephole / assembly-text layer: copt (80cc_rules.1 only) + the post-render text filter (dead-label elision, defc relocation, operand-rewrite jump threading) |
| [0014](0014-volatile-behaviour.md) | Volatile behaviour: VREG_VOLATILE locals, `mem.volatile_` derefs, the `;volatile` copt stamp |
| [0015](0015-ir-pattern-matcher.md) | The IR pattern-matcher engine: declarative production table (templates + check/apply + exclude_cpus), side conditions written once |
| [0016](0016-two-pass-lowering-and-carry.md) | Two-pass lowering: cross-BB register carry (bb_hl_out / byte-home), lazy spill (store-on-clobber), and rematerialisation |

Derived from the `*_PLAN.md` working notes: 0006 ← MULTICPU_IR, 0007 ← KIND_WIDTH,
0008 ← IVSR, 0009 ← the long-long/double accumulator design. Transient
per-optimisation plans (BC_PACK, PTRBENCH_*, the residency levers, MR_SQUASH,
REORG, the `*_BUG` post-mortems) stay as plans, not ADRs.

## Conventions

- **Status** of each ADR: Accepted / Superseded / Proposed.
- Performance figures live in commit messages and plan docs, **never in ADRs or
  code comments** (they go stale; the mechanism/rationale is what endures).
- Each residency feature is gated so the compiler is **byte-identical with it
  off** — see ADR 0004. New residency work should preserve that property.
