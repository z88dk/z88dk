# ADR 0005 — The runtime-helper clobber table (`__preserve_regs`)

Status: Accepted

## Context

Codegen synthesises calls to `l_` runtime helpers (multiply, divide, shifts,
long/float ops) that have no C prototype. In `op_clobbers` (ADR 0004) an `HCALL`
was modelled as `IR_R_ALL` — fully conservative: it may clobber everything. That
is safe but pessimistic: it means **no value can stay resident across any helper
call**, so a loop that calls (e.g.) `l_mult` every iteration cannot keep its
accumulator in a register — even though the integer helpers touch neither the
index registers nor the alt/shadow bank.

This is the compiler-internal half of the `__preserve_regs` idea (the header
attribute `__preserves_regs(...)` is the other, C-prototype half — parsed but not
yet consumed). See `PRESERVE_REGS_PLAN.md`.

## Decision

Maintain a small **audited whitelist** (`helper_preserves_index_alt`) of `l_`
helpers verified against the library asm to use neither IX/IY nor the alt bank —
the integer word/byte arithmetic family (`l_mult`, `l_mulu_32_16x16`, `l_div`,
`l_asr`/`l_lsr`/`l_lsl`, `l_neg`, …). For those, `op_clobbers(HCALL)` returns
`HL | DE | BC | A | F | MEM` and **preserves IX/IY/BC'/DE'/HL'**, so an index or
alt-bank home survives the call. Everything else — unknown, long/i64, float, far,
explicit index-manipulation helpers — stays `IR_R_ALL`.

The whitelist is **conservative by construction**: an omission costs residency
(the value spills), never correctness; only a mis-*inclusion* would be a silent
miscompile, so a name is added only after confirming its asm (all CPU variants)
is index- and alt-clean.

## Consequences

- Index/alt-bank residency (idx2/idx3, the IY reduction home, exx) can span a
  preserving helper call — the call-heavy hot loops (e.g. a dot product that
  calls `l_mult` per element) become reachable, not just the call-free ones.
- `IR_VERIFY` (ADR 0004) verifies the *call site* (`call l_x` touches no index
  reg), but **cannot** see inside the helper body — so the whitelist's safety
  rests on the manual asm audit, not the verifier. Grow it carefully.
- This is the seam for the full `__preserve_regs` feature: the header attribute,
  once consumed, would populate the same `CallInfo.clobbers`/`HelperInfo.clobbers`
  masks for C-prototype library functions (Track A), reusing this exact
  mechanism.
