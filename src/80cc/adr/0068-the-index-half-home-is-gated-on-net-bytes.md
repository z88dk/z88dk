# ADR 0068 — The index-half home is gated on net bytes

Status: **Accepted**.

## Decision

In sp mode, home a byte in an index-register half only when the half **saves
code**:

* `save_per` (3) ≈ a dear sp slot byte access (`ld hl,N; add hl,sp; ld a,(hl)`
  ≈ 5 B) minus `ld a,iyl` (2 B).
* `ovh` (10) folds the one-time push/pop index-register save (~4 B,
  `frame_has_saved_*`) **plus** the setup and move slop a low-access half-home
  incurs — a byte needing a CB-page shift or an HL transit cannot stay in a
  half, which is the op-shape term the model lacks.

## Two deliberate choices

**RAW, unweighted access counts.** Code size is static, not per-iteration, so
loop weighting would be wrong here. In sp mode the byte and cycle savings
correlate, so `net-bytes > 0` tracks the balanced win.

**Threshold calibrated by sweep**: home iff RAW accesses ≥ 4. That keeps
hot-accumulator shapes and rejects break-even shapes that only pay the save.
