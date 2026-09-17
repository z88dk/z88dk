# ADR 0090 — The short word right shift is a size regression

Status: **Rejected**, not built.

## Context

A masked word shift such as `(x >> 3) & 63` crosses the byte boundary. The
existing lowering shifts the word left and reads the high byte. On CPUs with CB
shifts, a right shift can use `srl h; rr l` and read the low byte.

## Decision

Keep the existing left-align lowering. Do not add the short-count right-shift
route.

The candidate saves cycles in hot loops, but it adds bytes at each site. The
Z80 corpus scan covered both frame modes. Four cells grew by 26 bytes in total.
Four cells became faster by 1,038,800 ticks in total. The other 56 cells did not
change. No cell became slower.

The largest clear case is a count-three shift. Five one-byte `add hl,hl`
instructions and `ld a,h` cost 6 bytes. Three `srl h; rr l` pairs and `ld a,l`
cost 13 bytes. The candidate saves about 7 T-states and adds 7 bytes.

The byte cost is not acceptable for a default-on change. Reopen this decision
only with a hot-loop or size-aware gate that proves the extra bytes pay back.
