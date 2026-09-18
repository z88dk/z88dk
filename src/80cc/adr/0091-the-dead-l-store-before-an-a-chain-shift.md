# ADR 0091 — The dead L store in front of an A-chain shift

Status: **Accepted** (2026-09-17). Opt out with `shr-dead-l`.

## Context

The A-through-CB word right shift (ADR 0090) is reached with the word load's
`ld l,a` in front of it, and the chain opens by loading the low byte straight
back with `ld a,l`. A already holds that byte, so the pair is a round trip: L
is written and read back with nothing in between.

Neither `srl h` nor `rra` reads L, and the chain ends by writing L again, so
both lines are dead.

## Decision

Drop the pair together, in `filter_dead_reg_copies`.

Dropping the pair is what makes it sound. Dropping only the store would leave
`ld a,l` reading a register nothing wrote. Dropping only the load is what copt
already does downstream, and that is precisely what stranded the store and made
this worth writing. Taken together, A is untouched and L is dead until the
closing `ld l,a`.

The match is narrow by construction: the only lines allowed between the pair
and that closing store are the chain's own two mnemonics, so there is no label
to enter at, no branch to leave by, and no other reader of L. The `ld a,l` is
optional in the match, so an emitter that elides it still gets the store
dropped — which is what keeps kc160 correct, where the value arrives by
`ld hl,(sp+2)` rather than through A and the load is therefore live.

## The trap this cost

The first version matched `ld l,a` followed directly by the chain and never
fired. The final asm shows only one of the two lines, which reads as if the
other was never emitted. It is: **copt removes the `ld a,l` after 80cc has
finished**, so at peephole time both lines are still present. An emitted trace
settled it; no IR dump could have, because copt is invisible to all of them.
Compiling at `-O0` did not settle it either — that output also lacked the line.

## Measurement

720-cell corpus against the same build with the gate off: **−18 bytes, 14 cells
smaller, 0 larger**. The focused `shrdeadl` test is −7 bytes and −52 T in both
frame modes, over seven shift sites: one byte each, because copt was already
taking the other.

Regression target `test/suites/long_ir/shrdeadl.c`, five variants (sp, fp, both
keeps, 8080). It covers counts 2..7 plus the two just outside the chain's range
— 1 stays on `srl h; rr l` and 9 takes the byte-move path — so a change to the
chain's bounds shows up as a wrong value, not only as a size difference.
