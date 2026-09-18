# ADR 0090 — The short word right shift is a size regression

Status: **Accepted** (2026-09-17). Widened the same day from Z80-only to every
CB-shift target — see the Widening section. Opt out with `shr-a-chain`.

## Context

A masked word shift such as `(x >> 3) & 63` crosses the byte boundary. The
existing lowering shifts the word left and reads the high byte. On CPUs with CB
shifts, a right shift can use `srl h; rr l` and read the low byte.

## Decision

Use the A-through-CB route for constant word right shifts with counts 2..7:

```text
ld a,l / (srl h / rra) × count / ld l,a
```

`rra` consumes the carry produced by `srl h`, so the sequence is equivalent to
`srl h / rr l`. The final `ld l,a` keeps the width-2 result in HL for its
consumer. Count 1 remains on the existing route.

## Widening (2026-09-17)

The step goes 4 bytes (`srl h; rr l`) to 3 (`srl h; rra`), and those encodings
are identical on every CB-shift target, so the SIZE argument does not depend on
the CPU. The original "plain Z80 until the others are measured" scope was
caution, not a capability limit, and it left four CPUs paying the old price.

Now enabled on **z80, z180, ez80, gbz80 and kc160**. Excluded, each because
something already beats the chain: z80n has the Next barrel shifter
(`bsrl de,b`), Rabbit has a native one-byte 16-bit `rr hl`, and the 808x/vm1
cores have no CB shifts at all and take a helper call. gbz80 is included: its
`rra` clears Z where the Z80's does not, which is harmless here because the
chain's flags are dead at the closing `ld l,a`.

Measured over the 720-cell corpus against a preserved HEAD binary:
**−178 bytes, 40 cells smaller, 0 larger** (gbz80 −56, z180 −48, ez80 −46,
kc160 −42). Ticks differ per core and are reported per CPU, never aggregated.

A clean Z80 corpus A/B scan covered 30 benchmarks in both frame modes: 60 cells,
10 changed, all 10 faster, none slower, for **−2,140,848 ticks** total. The
focused `shrmask` test passed in both modes and improved by 28 ticks in each.

## Correction (2026-09-17)

Two claims above were wrong, both found by re-measuring against a preserved
HEAD binary once the rung had an opt-out (`shr-a-chain`) to A/B with.

**The size claim.** "The full compile-only corpus size scan was unchanged" is
false. `IR_OFF=shr-a-chain` against the same build costs **+44 bytes over 10
cells**, so the rung was worth 44 bytes on z80 all along. The original scan
recorded no change because it could not isolate the rung — there was no gate,
so the A/B had to compare two built binaries, and that comparison did not
survive to be repeated. This is why ADR 0009's opt-out rule now covers every
code-changing rung: a rung that cannot be switched off cannot be measured.

**The route comparison.** "Still 4 bytes larger than the six-byte left-align
route in the count-three case" compares against a route the rung never reaches.
The left-align (top-byte) lowering is chosen earlier, in `gen_shr`'s
`IR_SHR_TOPBYTE` branch, and it keeps the masked shape — which is the shape
this rung was written for. The A-chain therefore only ever sees FULL-WIDTH
`x >> n`, where the comparison is against `srl h; rr l` and it wins on both
axes. The intended site in `histbench` (`bins[(seed >> 3) & BMASK]++`) was
never reached; that is a separate lever, now prototyped as `IR_SHR_TBAC`.

What the rung actually delivers on z80: **−44 bytes**, plus the ticks above.
