# ADR 0109 — A loop variable with a guarded decrement counts as non-negative

Status: **Accepted** (2026-10). `cmp-unsign-dec` opts out.

## Context

A down-counting loop variable can be proven non-negative when it is
initialised from a non-negative value and only decremented. a decrement that only runs when the
variable is non-zero was not recognised, so every signed compare against the variable kept its sign correction
(`rla; ccf; rra; sbc a,hi^0x80` for a word).

## Decision

`v_nonneg_iv` accepts a decrement that is guarded by a test of the variable
against zero, in a simple loop (`sd_dec_guarded`, `sd_simple_loop`, `sd_reach`).
`ir_opt_cmp_unsign` first decides for every compare in the function whether the
whole variable qualifies, then rewrites them; deciding and applying in one walk
let an early rewrite change the answer for a later compare.

## Evidence

Console -27 B. Test: `long_ir/downloop.c` (8 variants), including a variable
that reinitialises mid-loop and one that can go negative.

## Why this matters

Loop handling was the reason 80cc was started. This extends the proof; it does
not add a new special case for a particular loop shape.
