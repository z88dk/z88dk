# ADR 0051 — 8085 K-flag trip counters

Status: **Proposed** (2026-09-15). Surveyed and sized, not built.

Same family as ADR 0039 (LDSI slot addresses): a CPU capability the backend
declares and never uses.

## Context

`dec rr` sets no usable zero flag on the z80, so a 16-bit counted loop ends with
a three-instruction test:

```
dec hl / ld de,sp+6 / ld (de),hl / ld a,h / or l / jp nz,L
```

The 8085 has the **K flag** (bit 5, also X5/V) and the `jp k` / `jp nk` branches
(opcodes `FD` / `DD`, 3 bytes, 10/7 T). `CPU_HAS_JP_K()` exists in `define.h` and
**no backend file consults it** — one of five declared-but-unused capability
macros, and the only one that is not KR580VM1-only.

It is an established idiom elsewhere in this tree: **172 sites** in `libsrc` use
`jp k` / `jp nk`, including the sccz80 8085 comparison helpers and the micro8085
UART and SPI drivers.

## The opportunity

**236** `ld a,<hi>; or <lo>` 16-bit zero-tests in the corpus 8085 output. The
recurring shape has a `dec rr` three lines above the test, separated only by
LDSI and SHLX — and **neither writes flags** (`i8085_ld_de_spn` and
`i8085_ld_ide_hl` in `src/ticks/i8085_inst.c` only touch registers and `st`), so
K survives from the decrement to the test.

Each conversion drops `ld a,h; or l`: **2 bytes and ~8 cycles, and it frees A**.

The emulator models the flag correctly — `DECW` sets `fk = (a&b)==0xff` and
`INCW` sets `fk = (a|b)==0`, in `src/ticks/ticks.c` — so this is testable under
`z88dk-ticks` with no emulator work first.

## Why this is not a peephole

`jp nk` cannot simply replace `jp nz`. The repo's own 8085 notes state it:
**"K after `dec rp` sets on −1, not on 0."**

Our loops test `!= 0`; K reports `== -1`. Substituting the branch runs one extra
iteration. Making it correct means shifting the counter's **initial value by
one**, which is an IR loop transform, not a text rewrite — nearer the existing
`lftr` machinery than the post-pass rungs.

## Proposed scoping

Apply only to a **pure trip counter**: decremented in the loop, never read for
its value, dead after the loop. Shifting the init is then invisible, and no
other use needs a compensating `+1`. Anything else is out of scope.

Unknown, and the first thing to measure: **what fraction of the 236 sites are
pure trip counters.** Size that before building — the 236 is an upper bound on
sites, not on takeable ones.

## Effort

Two to three times ADR 0039, which was a text rewrite gated on liveness the
post-pass already computed. This needs a loop-shape analysis and an IV edit, so
it wants the full gauntlet plus a `long_ir` case whose valuable half is the
counters that must **not** be rewritten — one read inside the body, one live
after the loop, one incrementing rather than decrementing.
