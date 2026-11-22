# ADR 0096 — GBZ80 SP+0 word reads use pop/push for non-volatile slots

Status: **Accepted**, default on for GBZ80 SP-mode word loads at offset zero.

## Context

In GBZ80 SP mode, a 16-bit local at `sp+0` was read by computing the stack
address in HL and loading the two bytes. The Game Boy CPU can instead read the
word with `pop hl; push hl`. This is both smaller and faster for this read.
The push writes the word back to the same slot. That write is unobservable for
a non-volatile local, but it is an extra observable access for a volatile
local, so this is not a general replacement for a load.

The shared TOS predicate also controls stores, in-place updates, slot ordering,
and epilogues. Enabling it wholesale would change more than this measured load
case, so this decision uses a separate, narrow predicate.

## Decision

Extend `load_to_hl_adj`'s SP+0 word TOS path to GBZ80 for a two-byte vreg only
when the function uses an SP-relative frame, the slot offset is zero, and the
vreg is non-volatile.

`push hl` writes the word back, so non-volatile eligibility applies to the TOS
load path on every CPU. This prevents an extra observable access to a volatile
local without changing existing non-GBZ80 eligibility.

The `gbz80-tos-read` `IR_OFF` feature gate disables the GBZ80 extension.

The GBZ80 copt rules G5, G7, and G8 clean up register copies around the new
sequence: G5 avoids an expensive synthetic `ex de,hl`, G7 removes a dead
DE-to-HL copy, and G8 reads the word directly into DE when HL is immediately
reloaded. These rules are restricted to GBZ80.

## Regression coverage

`test/suites/long_ir/long_ir.c` exercises both sides of the volatile boundary.
`lr_word_cmp_tos` keeps ordinary word locals live across a call and exercises
the stack-slot load; `lr_volatile_word_cmp_tos` verifies that volatile locals
retain a read-only frame load. The existing long compare test also covers the
four-byte TOS path.

The feature was validated with the `long_ir` SP and FP suites, both IR
verifiers, the all-CPU corpus size and tick scans, the console behavior gates,
and the full benchmark matrix. The `gbz80-tos-read` opt-out was checked against
the saved pre-change compiler: corpus sizes and ticks matched exactly, and the
regression-function assembly was identical. The dated measurement summary is
archived locally in `test/suites/BENCH_MATRIX.history.txt` under the
20/9/2026 GBZ80 TOS word-read run; the current complete matrix is
`test/suites/BENCH_MATRIX.txt`.

## Consequences

This is a load-specific GBZ80 optimization, not a general endorsement of the
push/pop TOS model for word operations. In particular, volatile accesses must
not use the write-back sequence. The nonvolatile check also constrains the
pre-existing TOS path on other eligible CPUs. The `gbz80-tos-read` opt-out
restores only the GBZ80 extension; it does not disable the shared volatile
check.
