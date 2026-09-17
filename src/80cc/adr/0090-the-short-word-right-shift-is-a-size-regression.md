# ADR 0090 — The short word right shift is a size regression

Status: **Accepted** (2026-09-17), Z80-only.

## Context

A masked word shift such as `(x >> 3) & 63` crosses the byte boundary. The
existing lowering shifts the word left and reads the high byte. On CPUs with CB
shifts, a right shift can use `srl h; rr l` and read the low byte.

## Decision

Use the A-through-CB route on plain Z80 for constant word right shifts with
counts 2..7:

```text
ld a,l / (srl h / rra) × count / ld l,a
```

`rra` consumes the carry produced by `srl h`, so the sequence is equivalent to
`srl h / rr l`. The final `ld l,a` keeps the width-2 result in HL for its
consumer. Count 1 remains on the existing route, and other CB-shift CPUs are
not enabled until measured separately.

A clean Z80 corpus A/B scan covered 30 benchmarks in both frame modes: 60 cells,
10 changed, all 10 faster, none slower, for **−2,140,848 ticks** total. The
focused `shrmask` test passed in both modes and improved by 28 ticks in each.
The representative size witness lost 7 bytes, while the candidate route is
still 4 bytes larger than the six-byte left-align route in the count-three
case. The full compile-only corpus size scan was unchanged; the tick win is
therefore accepted as a measured Z80 trade-off with no corpus size regression.
