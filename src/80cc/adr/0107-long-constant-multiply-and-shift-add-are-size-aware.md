# ADR 0107 — Long constant multiply is expanded inline only when it is shorter than the call

Status: **Accepted** (2026-10). `long-mult-sr` and `shl-add-pair` opt out.

## Context

A long multiply by a constant can be strength-reduced into shifts and adds.
Every shift and add on a 32-bit value is several instructions, so the
expansion grows with the number of set bits. The alternative is
`ld hl,nnnn; ld de,nnnn; call l_long_mult_u`: 9 bytes however large the
constant is. The expansion was emitted for any constant, and for constants
such as 6, 10 and 24 it was longer than the call.

## Decision

`emit_const_mult_sr` expands a width-4 multiply inline only when the constant
has a single set bit, two set bits with the lower at bit 0 (2^a + 1), or one
run of set bits starting at bit 0 (2^a - 1 and kin): a shift and at most one
add or subtract. Every other constant calls the helper. This is a size
rule and costs ticks on the outlined constants; that trade was chosen
deliberately, because the helper call is the smaller form and the speed-optimised
expansion stays available for the shapes where it is also smaller.

A long `(x << n) +/- x` keeps `x` on the stack across the shift and pops it
for the add or subtract (`shl-add-pair`), instead of reloading `x` from its
frame slot with a byte walk.

## Evidence

Regression cases: `long_ir/longmultgate.c` (every CPU and both frame modes),
`ivpair.c`.

## Reopen if

A ticks-first mode exists. The expansion is correct for every constant; only
the gate is size-driven.
