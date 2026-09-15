# ADR 0043 — A pushed long parameter is carried past the prologue

Status: **Accepted**, default on. `IR_FCLONG_CARRY=0` opts out, byte-identical.

## Context

An auto-pushed width-4 fastcall parameter arrives in DE:HL. The prologue push
materialises its slot — and then the first read loaded all four bytes back out
of the slot the push had just written.

## Decision

Carry the value in its arrival registers past the prologue. The long is still in
DE:HL after the push, so one `ld bc,hl` re-establishes the DEHL cache invariant
(BC holds the low half) and the first read is free.

See the `[IR_FCLONG_CARRY]` sites in `emit_prologue`, `fclong_carry_pays` (which
keeps the stash out of functions it cannot pay for), and the `entry_dehl` seed in
`ir_lower_func` — the entry BB clears `rs.dehl` unconditionally, so the claim has
to be re-asserted there.

## Consequences

**The bench corpus does not contain the shape**: 638 cells byte-identical either
way, as are `adv_a` and `clisp`. The evidence is `emu.c` **−60 B fp / −51 B sp**
and `long_ir/fclong.c` −32 B, with ticks following the bytes (a 4-byte `(ix+d)`
reload replaced by one register move).

Gates: `long_ir` 650/650 sp+fp, `enigma` sp+fp, `emu.c` behavioural sp+fp,
`IR_CLOB_VERIFY` unchanged at its 4 pre-existing sites.

This is one of several optimisations whose value is invisible to the corpus — see
ADR 0044 for the other. A zero corpus delta is not evidence that a change does
nothing; it is evidence that the corpus lacks the shape.
