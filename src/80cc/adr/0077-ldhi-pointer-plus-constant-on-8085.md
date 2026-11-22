# ADR 0077 — LDHI pointer-plus-constant on the 8085

Status: **Accepted**, default on. `--opt-disable=ldhi-addr` opts out.

## Context

LDSI's sibling, found by the same CPU sweep (vein 1 of the design index) and
sized from the same census method. Adding a small constant to a value already
in HL cost `ld de,N; add hl,de` — 4 bytes, 20 cycles — the z80 sequence. The
8085 has LDHI (`ld de,hl+N`, opcode 28, 2 bytes, 10 cycles per
`i8085_ld_de_hln` in `src/ticks/i8085_inst.c`), so the same sum costs
`ld de,hl+N; ex de,hl`: **3 bytes and 14 cycles**.

The dominant shape is a member store through a pointer parameter — `p->field =
…` forms `pointer + member offset` — which is why `md5`, `structbench` and
`recordbench` carry most of the sites. It is not address-specific, though: any
`HL += small constant` qualifies, and `n * 3 + 11` converts too.

## Decision

The same post-pass in `ir_lower.c`, immediately after the `[ldsi-addr]` rung,
on the same per-register backward liveness fixpoint. Three conditions:

* **D and E dead after the pair.** Here it is not `ex de,hl`'s swap that
  demands it: the original pair leaves DE holding **N**, and the rewrite leaves
  it holding the **old HL**, so a reader of either sees a wrong value.
* **F dead after the pair.** `add hl,de` (DAD D) **writes carry**; LDHI does
  not.
* **N in 0..255.** LDHI's operand is one unsigned byte. Out-of-range is common
  for this rung, unlike LDSI: the added constant is program data rather than a
  frame offset, so bench magic constants (13849, 20973, 48879) land here — 24
  of the 63 census sites were out of range on that account alone.

One line of `instr_effects` was tightened as a prerequisite: its gbz80
auto-step test matched bare `"hl+"`, which would also read `ld de,hl+N` as a
write of HL. It now requires the parenthesised form `"(hl+)"`, which is the
only shape the lowerer emits. Proven inert — see below.

## Consequences

Measured on the 720-cell size matrix and the 8085 tick matrix, both frame
modes:

* **size −66 bytes**, 14 cells smaller, **0 larger**
* **ticks −0.0224 %** (−577932), 14 cells faster, **0 slower**, 60/60 cells
  `fail=0`
* **gate-off is byte-identical to the pre-change compiler in all 720 cells**,
  which is also the proof that the `instr_effects` tightening changes nothing
* `long_ir` **775/775 in both frame modes** (769 before the six new targets);
  the only failure is the pre-existing `longshl_vm1`, which has no assembler
* behavioural gates green both modes: `enigma` RXSEC, `clisp` 6/42, `adv_a`

The census found 63 `ld de,N; add hl,de` pairs in the corpus, 39 within LDHI's
range; 38 of those 39 convert, the realised saving landing above the site count
because a few sites appear in more than one CPU-mode cell.

Regression test `test/suites/long_ir/ldhiaddr.c`, six targets including
`_8085_keep` (gate off) and `_8080` (a CPU with no LDHI, the control). Its
value is in the functions that must **not** change, and each claim was checked
by diffing the 8085 asm per function, gate-on against gate-off: exactly two
functions differ. `big_off` carries **both** decline classes — two in-range
formations declined because DE is live after them, three declined on range.

`carry_live` produces no adjacent candidate pair today, so it is a tripwire on
a future widening rather than a live gate, and the test says so. The first draft
also claimed a `de_live` guard it did not exercise: the rung fired there, on an
unrelated `+11`, and the function was renamed `const_add` to say what it really
pins. **That is the LDSI lesson repeating** — diff per function before
believing a codegen test.
