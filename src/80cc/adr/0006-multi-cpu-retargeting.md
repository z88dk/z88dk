# ADR 0006 — Multi-CPU retargeting

Status: Accepted

## Context

z88dk targets a family of 8-bit CPUs: the Z80 supersets (z80n, z180, ez80,
rabbit/r2ka…r6k, kc160) and the leaner relatives (gbz80, 8080, 8085). 80cc must
emit correct — and where possible, better — code for all of them from one IR,
without smearing CPU conditionals across the whole compiler.

## Decision

Keep the pipeline **CPU-agnostic up to the lowerer** (ADR 0001): `ir_build`,
`ir_opt`/`ir_match`, and `ir_alloc` reason about vregs and effects, not
instructions. **All CPU knowledge lives in `ir_lower`** and is driven by:

- The global `c_cpu` and predicates `IS_Z80N()/IS_EZ80()/IS_RABBIT()/IS_GBZ80()/
  IS_8085()/IS_KC160()`, `c_cpu == CPU_Z80/Z180`.
- Per-`Func` **feature bits** (`IR_FEAT_CB_BITOPS / EX_DE_HL / IX / DJNZ`, …)
  stamped by `ir_features_from_cpu()`, consulted by `ir_match` fusions and the
  lowerer's substitutions.

Two workstreams, by CPU class:

- **Exploit** (supersets: ez80, z80n, rabbit, kc160) — already correct as Z80;
  work is pure optimisation using the richer instructions (hardware multiply,
  native `ld rr,(sp+d)`, `mlt`, `add iy,de`, …). Residency/codegen features are
  CPU-gated on to these where they pay (ADR 0002/0003).
- **Substitute** (leaner: gbz80, 8080, 8085) — must *replace* Z80-only idioms:
  no `ex de,hl`, no `(ix+d)` frame access, no index registers at all. The
  lowerer emits the equivalent (e.g. copy via a scratch, sp-relative addressing).

z80asm already encodes every target's mnemonics, so this is purely a
compiler-*emission* problem — no assembler work.

## Consequences

- A residency or codegen feature is only enabled where the CPU supports its
  primitive (e.g. the IY reduction home needs `add iy,de` → z80/z80n/z180/ez80/
  rabbit; excluded on gbz80/8080/8085/kc160). Gating lives at the feature's
  admission check, not scattered.
- The correctness matrix is **all CPUs**: the test suites run each program across
  the full CPU set (per-CPU exit-checked), because a Z80-correct change can emit
  an illegal instruction on gbz80/8080/8085.
- Frame addressing has three modes (sp / `-frameix` / `-frameiy`) that the
  lowerer selects; features that touch the frame or index registers must respect
  which register is the frame pointer (see ADR 0002).
