# ADR 0111 — A long operation on a global reads it in place

Status: **Accepted** (2026-10). Opt-outs: `long-mem-rhs`, `long-rmw-walk`.

## Context

`a += b` on long globals loaded `a`, loaded `b`, parked `b` in a frame slot,
walked it back out byte by byte and stored `a`. Globals are the common way to
hold counters, accumulators and flags on a Z80, so this shape is frequent
outside the benchmark corpus, which has none: it only showed up in the console
programs (`umchess`).

## Decision

A width-4 integer global load whose single use is the immediately following ADD,
SUB, AND, OR or XOR is not loaded (`long-mem-rhs`). The consuming op reads the
global in place:

| CPU class | add / sub | and / or / xor |
|---|---|---|
| Z80 family, Rabbit, kc160 | `ld bc,(sym)`, `add/adc/sbc hl,bc` | `ld a,(sym+i)`, op `l/h/e/d`, `ld r,a` |
| 8080, 8085, vm1, gbz80 | walk `(hl)` through A, result in BC/DE | absolute reads (not gbz80) |

For `g op= h` on 8080, 8085, vm1 and gbz80 whose result only feeds the store
back to `g` (`long-rmw-walk`), the whole load-load-op-store is replaced by two
pointers and four bytes through A. On gbz80 the commutative operations use
`ld (hl+),a`; subtract swaps the pointer roles. The store is skipped.

## Evidence

Bytes for `a += b`: Z80 58 -> 32, 8080 61 -> 25, gbz80 67 -> 22. `a -= b`:
Z80 79 -> 34, 8080 -> 25. `c = a + b - t`: Z80 110 -> 47. `umchess` -171 B sp,
-70 B fp. Tests: `longmemrhs.c` (11 variants, includes `a op= a`), and
`longmempark.c` for the miscompile below.

## Bug found on the way

An operand parked on the data stack by `IR_PUSH_DEHL_LONG` was loaded as if it
were in registers, so the stack stayed 4 bytes out at the join; only `umaxd` in
fp mode noticed. The prepass now skips that shape. `longmempark` reproduces it
in a small file: in the larger test the code generated for the function was
different and the bug did not show.

## Tried and refused

- 8085 word-wise route using `lhlx`/`shlx`: 29 B against the walk's 25 B, and
  about 142 against 120 T-states. The 8085 has no add-with-carry on HL, so the
  high word is byte-wise anyway.
- vm1 `sbc hl,bc` for the low half: vm1 cannot load BC from memory (the
  assembler synthesises 7 bytes), so it stays on the byte path.
- Absolute-read add/sub on gbz80: +2 B on `a += b`, +6 B on `c = a + b - t`.
- The pointer walk for the Z80 family: 24 B against 27 for the register form,
  for about 100 more T-states (hand count).

## Not done

Long compares against a global (`a > b` is 60 B against 20 for sccz80), and the
retained-result form of the gbz80 walk.
