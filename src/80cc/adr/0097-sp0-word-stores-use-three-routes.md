# ADR 0097 — SP+0 word stores use three routes

Status: **Accepted**. The measured selector is default-on only for GBZ80;
other CPUs retain their previous non-volatile lowering until the selector can
be enabled without any size or tick regressions.

## Context

On CPUs without a usable native `ld (sp+n),hl`, a word store at the top of the
frame must replace the old slot while keeping the new value in HL. The old
`pop de; push hl` route is efficient only when DE's cached value is dead, and it
reads the old slot. That read is not valid for a volatile store. The general
three-route selector had losing size or tick cells outside GBZ80, so the default
policy is CPU-specific rather than accepting cross-CPU regressions.

## Decision

Use an ordered, liveness-aware selector for SP+0 stores:

1. `pop de; push hl` when DE has no live tenant and no byte home depends on it.
2. `pop af; push hl` when A is free and the CPU permits POP AF for this use.
   VM1 never takes this route: PSW bit 3 selects its memory bank.
3. `inc sp; inc sp; push hl` when the store must preserve the other register
   homes, or when it is volatile. This route discards the old slot without
   reading it, so volatile stores remain write-only.

The third route is CPU-priced: on Z80 it costs 2T more than POP/PUSH; on
GBZ80 it costs 4T more. Other CPUs use their own instruction timings. CPUs with
a usable native SP-relative store keep that direct route. At an 8085 K-trip
boundary, lowering suppresses the AF and INC SP rungs; the DE rung remains
available when DE is dead.

On GBZ80, `tos-store` disables the selector (`--opt-disable=tos-store`, or
`IR_OFF=tos-store` in corpus measurements). Other CPUs currently use their
previous non-volatile lowering regardless of this option. The volatile
write-only route is unconditional on CPUs that need it; disabling the selector
does not allow volatile stores to use a read-modify-write sequence.

## Regression coverage

`lr_word_store_tos` forces a call result to be stored in the top frame slot and
keeps it live across another call. Its volatile sibling,
`lr_volatile_word_store_tos`, checks that a volatile TOS store remains
write-only. Both are covered by `long_ir`.

## Evidence

The dated top section of `test/suites/BENCH_MATRIX.txt` records the latest
80cc-sp measurements and exact-tick scan across 30 benchmarks and eight
affected CPUs: GBZ80 is smaller and faster in all 30; the other seven CPUs
match the previous lowering in all 210 cells. There are no losing cells. The
focused `long_ir` regression suite passed 47/47 on Z80, GBZ80, 8080, and 8085.
