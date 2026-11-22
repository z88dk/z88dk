# ADR 0045 — `xor a` rides the backward flag sweep

Status: **Accepted**, default on. `IR_OFF=xor-a` opts out, byte-identical.

## Context

`ld a,0` is 2 bytes and 7 T; `xor a` is 1 and 4. The only difference is that
`xor a` **defines the flags** — and the lowerer cannot say whether that matters,
because it models registers, not F.

## Decision

The rendered text *can* say. The rewrite rides the backward park sweep, which
already walks each function bottom-up with one `instr_effects` call per line, and
asks: does this line read the flags?

Anything not recognised as flag-transparent answers **yes**, so the sweep can
only ever be too careful. Two deliberate readings:

* a branch or call answers yes, because its successor is outside this walk;
* a **conditionless `ret`** answers no — F is dead at a function exit (the return
  ABI is A / HL / DE:HL), the same assumption the BC sweep already makes for BC.

## Consequences

Corpus **−230 B over 132 cells with zero larger**, every CPU smaller: gbz80 −40,
8080/8085 −26, z80/z80n/z180 −25, rabbit/ez80/kc160 −21. `emu.c` −38 B fp /
−52 B sp. Ticks follow — 7 T becomes 4 T at every site and nothing else moves.

Because the rewrite rides the park sweep, `--opt-disable=bc-live` also turns it
off. That coupling is not obvious from the gate name and is worth knowing before
bisecting with it.
