# ADR 0042 — A narrowing result stays in HL

Status: **Accepted**, default on. `IR_OFF=trunc-res` opts out, byte-identical.

## Context

A long→int narrowing leaves its result in HL, but the lowerer spilled it and
then invalidated the cache — so a consumer one op later reloaded the slot that
had just been written.

## Decision

Say where the value is. `commit_hl_result` records HL as holding the result,
which also lets the dead-store pass drop the spill outright, and routes a
`PR_DE` destination into DE. See `gen_conv_trunc`.

## Consequences

Corpus **−285 B over 38 cells with zero larger**, every CPU gaining: gbz80 and
8085 −30, z80/z80n/z180 −28, rabbit and 8080 −26, kc160 −20, ez80 −17. Real
files: `emu.c` −210 B sp / −247 B fp, `clisp` −212 / −146. Ticks follow the
bytes — z80 corpus −0.131 %, 3 cells faster and 0 slower.

## Two notes for whoever touches it

This needed the `expr.c` member-offset fix **first**. Until then it miscompiled
`long_ir/aggregate_init` in sp mode — through no fault of its own: `s.arr[i]` on
a local struct was reading past the end of the struct, and this change moved
which garbage landed where, so the test's sum stopped cancelling to zero. A
miscompile that appears when an unrelated change lands is not necessarily that
change's fault.

The 2→2 narrowing case is left on the old path. It was never measured on its own.
