# ADR 0007 — The type-kind / width model on VRegs

Status: Accepted (enforcement hardening ongoing)

## Context

Every `VReg` carries two type axes: a **`kind`** (`KIND_CHAR/INT/LONG/PTR/CPTR/
FLOAT/…`) and a **`width`** in bytes (1/2/4/6/8). The lowerer and analyses switch
on both — width for how many bytes to move/compute, kind for signedness and
pointer-ness. Keeping the two consistent is a correctness requirement, and a
recurring source of bugs when they drift.

## Decision

- **The constructors keep kind and width consistent by construction:**
  `ir_vreg_new(kind)` sets `width = kind_width(kind)`; `new_temp(width)` sets
  `kind = int_kind_for_width(width)`; `new_temp_kind(kind)` derives the width.
  Create vregs through these.
- **Kind is the authoritative axis; width is derived from it.** Where they
  disagree, kind is intended to be the truth (a `KIND_LONG` value is 4 bytes even
  if a stray `width` says otherwise).
- **`IR_VERIFY` cross-checks the invariant** (`ir_analysis.c`: "kind K implies
  width W but width is X"), the same verify discipline as `op_clobbers`
  (ADR 0004).

## Consequences

- **The known hazard:** many `f->vregs[v].width = X` *mutations* scattered
  through `ir_build.c` (binop result widths, CONV dsts, widenings) change `width`
  without updating `kind`, so the two can diverge. That divergence is the root of
  the `umaxd` fp abort class: the width-based lowering widens an operand *by its
  width*, and a `kind=LONG,width=2` vreg then reads/extends the wrong number of
  bytes. sp-mode often masks it (slot-backed, silently wrong); fp fail-safe
  aborts. See `KIND_WIDTH_REFACTOR_PLAN.md`.
- **The hardening (planned, not complete):** route width changes through a
  mutator that updates kind (or forbid raw width writes), then promote the
  `IR_VERIFY` kind/width check from warning to enforced. Until then, treat a
  kind/width mismatch report as a real bug, and prefer the constructors over raw
  `.width =` when writing new IR-building code.
- The wide (6/8-byte) kinds are handled specially — not in registers — see
  ADR 0009.
