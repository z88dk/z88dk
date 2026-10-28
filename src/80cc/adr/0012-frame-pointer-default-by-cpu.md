# ADR 0012 — Per-CPU default for the frame pointer

Status: Accepted (the default flip is still pending — see Consequences)

## Context

ADR 0011 describes the two frame modes: `-fframe-pointer` (IX is a frame pointer,
locals addressed `(ix+d)`) and `-fomit-frame-pointer` (no frame pointer, locals
addressed relative to SP). The current default is sp (omit) on every CPU, chosen
historically for *correctness* (see below), not speed.

A full benchmark sweep (BENCH_MATRIX.txt, 16/7 snapshot — 23 benches × the CPU
matrix, fp vs sp) shows the mode choice is not uniform across CPUs. Whether fp
helps depends on one architectural property: **does the CPU have cheap
stack-relative addressing?**

- **z80 / z80n / z180** have neither native `ld rr,(sp+d)` nor 16-bit indexed
  loads. In sp mode every local address is materialised with
  `ld hl,off; add hl,sp; …`; fp reads it in place via `(ix+d)`. fp is faster and
  smaller across essentially the whole suite.
- **ez80** additionally has native 16-bit indexed load/store `ld rr,(ix+d)` /
  `ld (ix+d),rr` — a single instruction that *only* fp can use (there is no
  `ld rr,(sp+d)` in z80 mode). On 16-bit-heavy code this is a large win; fp is
  both much faster and smaller. This is the strongest case in the matrix.
- **Rabbit (r2ka / r4k) and kc160** have native cheap **stack-relative**
  addressing, so sp is already as good as `(ix+d)`. fp then only adds IX
  save/restore overhead and larger encodings — a net wash-to-loss, and bigger
  code.
- **gbz80 / 8080 / 8085** have no index registers, so fp is impossible; sp is
  forced (`c_framepointer_is_ix` is already pinned to -1 for these in main.c).

## Decision

Make the frame-pointer default **per-CPU**:

- **Default `-fframe-pointer` (IX frame): z80, z80n, z180, ez80.**
- **Default `-fomit-frame-pointer` (sp): r2ka, r4k, kc160** (and gbz80 / 8080 /
  8085, where it is forced).

Both flags remain user-overridable on every CPU (ADR 0011); this only changes the
default `c_framepointer_is_ix` chosen per CPU in the CPU-setup code.

## Consequences

- **Call-site IX safety is ADR 0122.** A function that keeps a frame saves
  that register around each `IR_CALL`. A callee that changes IX no longer
  breaks `ld sp,ix` in that caller. The sccz80 library is unchanged. sccz80
  does not keep a frame in IX, and both compilers link the same library.
  The default flip below is still not done. It remains a separate decision.
  Do not set `c_framepointer_is_ix` from the call-site save.
- Implementation is a per-CPU assignment of the default `c_framepointer_is_ix`
  (1 for z80/z80n/z180/ez80, -1 otherwise) in main.c's CPU setup, replacing the
  current uniform -1 default. The existing forced -1 for gbz80/8080/8085 stays.
- Test infra already exercises both modes (`FP=1` builds the fp variant); after
  the flip, the *default* suite run covers fp on the four CPUs and the `FP`
  toggle should be re-pointed to exercise the non-default mode if per-mode
  coverage is still wanted.
- Numbers backing this live in BENCH_MATRIX.txt (per the ADR convention, kept out
  of this document); re-check them if the CPU cost model or residency changes.

See ADR 0011 (index-register roles / reservation), ADR 0002 (register model),
and ADR 0122 (the frame register saved around each call).
