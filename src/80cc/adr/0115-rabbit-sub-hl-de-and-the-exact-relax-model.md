# ADR 0115 — No `sub hl,de` on the Rabbit 2000/3000, and an exact `jr` size model

Status: **Accepted** (2026-10). No opt-out: the first is a correctness-of-cost
fix, the second only narrows an upper bound.

## Context

`queenbench` on r2ka was 17.07M T against sdcc's 9.98M. Its inner loop has two
word subtracts. The lowerer emitted `sub hl,de` for every Rabbit, but the
instruction is native only on the Rabbit 4000 and 6000 (`0x55`). On r2ka and
r3k z80asm assembles it as `call` to a helper (`cd 00 00`). Every other
synthetic in the bench set assembles to real instructions (scanned on r2ka, z80,
z180, gbz80, kc160, z80n; ez80 not scanned).

The same loop kept two 3-byte `jp` that fit `jr`. The relaxation pass
(ADR 0033) charges 4 bytes for every instruction it does not know, including
1-byte ones, and 6 for every `(ix+d)` form, about twice the real span.

## Decision

- `sub hl,de` is emitted only for Rabbit 4000+ (`IS_RABBIT4K()`). r2ka and r3k
  use `and a; sbc hl,de`, and the subtrahend-in-BC form (`and a; sbc hl,bc`)
  now fires there too.
- `relax_line_size` charges 2 bytes for register-only forms (8-bit `ld r,r`,
  `inc`/`dec`, `push`/`pop`, `ex de,hl`, accumulator ALU ops, `add hl,rr`, `ret`)
  on z80, z80n, z180, r800, r2ka, r3k, gbz80, ez80 and kc160. Rabbit 4000+ keeps
  the loose bound: its extended ALU and SP-relative forms sit behind a prefix.
  80cc emits no ADL-suffixed or prefixed code for ez80 or kc160, but an `__asm`
  block may, so those two fall back to the loose bound in a function that
  contains one.
- A `jp cc,L / jp M / L:` window is still left to copt (`#JI`), so a loop whose
  exit test is inverted by copt is not relaxed here. That is why the test uses a
  forward branch.

## Evidence

Old compiler against new, 62 bench cells per CPU, both frame modes: size -486 B
in total, no cell larger (z180 -85, gbz80 -78, kc160 -68, r2ka -65, ez80 -64,
z80 and z80n -43, r800 -40; the Intel cores and r4k/r6k unchanged). Ticks: r2ka
-2.51 % (48 cells faster, none slower), ez80 -0.19 %, gbz80 -0.09 %, z180
-0.02 %, kc160 unchanged, z80 -0.06 % with 3 cells up by at most 0.05 % (a taken
`jr` is dearer than a taken `jp` there). `queenbench` r2ka fp: 3429 -> 3410 B,
17.07M -> 13.16M T. Tests: `long_ir/rabsub.c` and `jrtight.c`, each with a Makefile
check of the rendered asm that fails on the previous compiler.

## Costs and what was refused

A Rabbit `ld de,(ix+d)` and `ld bc,(ix+d)` are two byte loads (6 B) on every
Rabbit; only HL has the single instruction. The model still charges 6 for all
`(ix+d)` forms. Sharing the two `return` epilogues of `safe()` is not possible
with the tail merger as it stands: a copy already merged into another block
claims that tail, so a third block cannot join it.
