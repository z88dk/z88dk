# ADR 0116 — A long carried through a loop, and constant long shifts

Status: **Accepted** (2026-10). Opt-outs: `long-asr-const`, `long-shr-bc`,
`long-shl-tos`, `long-shl-tos-cache`, `tos-rmw`, `iv-narrow-latch`, `step-z`,
`step-mem`, `long-zx-fold`.

## Context

The `z88dk-ext` survey (86 integer-only files, 80cc against sdcc) put 80cc 11.9 %
larger, spread over register moves and constant loads. The worst small files
were bit-serial loops carrying a `long`: `misc/crc` was 319 B against sdcc's 159.
`crcbench` hides this: it shifts right in an unrolled body and both compilers
spill the long. The new `lshiftbench` (bit-serial CRC-16 with a left-shifted
long, constant long shifts, byte packing) does not: on z80 it was 26.5M T for
80cc with the frame pointer against sdcc's 9.9M.

## Decision

- A constant arithmetic long `>>` is inline: whole bytes move down with the sign
  byte filling the top, the remaining bits go through `sra` and `rr`. It was a
  call to `l_asr_dehl`. 8080-family keeps the helper.
- A bit-only right shift (logical and arithmetic) of a long runs on D,E,B,C. A
  long load already leaves BC = low half and DE = high half, so the old
  `ld hl,bc ... ld bc,hl` pair goes. A counted shift loop counts in A, since B is
  part of the value. Not on Rabbit, kc160 and ez80, where the native long store
  from HL is shorter.
- A long left shift by 1 on a slot at the top of the stack is `pop hl; pop de;
  add hl,hl; rl e; rl d; push de; push hl`, and the result is claimed in the
  DE:BC cache so a test of one byte reads the register.
- A long read-modify-written at the top of the stack drops its copy
  (`pop hl; pop de; push de; push hl`) and its replacement pops when only
  register operations lie between them.
- `ir_opt_narrow_iv` also narrows a down-counter tested in the loop latch after
  its own decrement (seed 1 to 255), including the branch-if-nonzero form.
- A long AND/OR/XOR whose operand is a single-use zero-extended frame word or
  byte reads the word's bytes straight from the frame in frame-pointer mode: the
  extend is not emitted, the bytes above the word are zero (a copy of the other
  operand for OR/XOR, a constant for AND). Elsewhere the user builds the extend
  itself. Test: `long_ir/zxfold.c`.
- A byte inc/dec of a frame slot onto itself is `dec (ix+d)` or `dec (hl)`, and
  its Z flag feeds the following zero test.

## Evidence

`lshiftbench`, z80, frame pointer / sp: 26.5M / 29.5M T to 17.5M / 19.3M T
(-34 %), 4956 / 5119 B to 4880 / 5031 B. r2ka -20 %, ez80 -35 to -42 %, kc160
-30 %, gbz80 -28 %, 8080 and vm1 -14 %. sdcc is 9.9M, so the gap is 1.8 x from
2.7 x. Corpus (806 cells): -5787 B, 114 cells larger (mostly a BC-resident
counter becoming a byte slot: `interpbench`, `intbench`), no cell more than
0.2 % slower, no tick check failed. Tests: `long_ir/longasr.c`, `crcloop.c`.

## Costs and what was refused

The long still lives in memory across the loop; sdcc keeps it in `c,b,e,d`.
That needs an allocator home for 32-bit values and is the remaining 1.8 x. A
latch-test gate that narrowed only in loops using a long recovered the
`intbench` bytes but lost the 5 KB elsewhere, so it was dropped.
