# ADR 0078 — `add hl,a` on the z80n for a zero-extended byte

Status: **Accepted**, default on. `--opt-disable=z80n-add-a` opts out.

## Context

Adding a zero-extended byte to HL cost `ld e,a; ld d,0; add hl,de` — 4 bytes,
22 cycles — and it spent DE. The z80n has `add hl,a` (ED 31, 2 bytes, 8 cycles,
`z80n_add_hl_a` in `src/ticks/z80n_inst.c`), which adds A zero-extended and
leaves DE alone.

Found by the CPU sweep. The design index sized this as "48 byte-widen-then-add
pairs"; the census found **20**, of which 19 are reachable in principle.

## Decision

A rung in the emitted-text post-pass in `ir_lower.c`, beside `[ldsi-addr]` and
`[ldhi-addr]`, on the same backward liveness. Conditions:

* **D and E dead after the add.** The pair's zero-extended value stops
  existing; DE reverts to whatever it held before.
* **F dead after.** `add hl,de` writes carry and `add hl,a` writes **no flags
  at all**, so a consumer would read a stale one.
* **A preserved between the widen pair and the add, and D/E unread there.**
  The pair is usually not adjacent to the add — the base arrives in between, as
  `ld e,a; ld d,0; pop hl; add hl,de`, which is 14 of the 20 sites — so
  `zn_widen_pair_for` walks a bounded window backwards and requires every line
  in it to preserve A and leave D and E alone. A label, a branch, a call or an
  unrecognised line ends the window: the claim is straight-line only.

## Consequences

Measured on the 720-cell size matrix and the z80n tick matrix, both frame
modes:

* **size −10 bytes**, 5 cells smaller, **0 larger** — and exactly 5 cells
  change in the whole 720, all of them z80n, so there is no leak
* **ticks −0.0440 %** (−1100400), 5 cells faster, **0 slower**, 60/60 `fail=0`
* `long_ir` **781/781 in both frame modes**

**Only 5 of the 20 census sites convert, and the reason is worth more than the
rung.** The other 15 are declined because DE reads as live after the add, and
in most cases that is `instr_effects` being deliberately conservative rather
than DE being genuinely needed: **a `call` reads DE** (the `__sdcccall(1)`
argument ABI) and **a `ret` reads DE** (the long and float result ABI is DE:HL).
`divbench`'s `udiv` is the clearest case — `add hl,de; pop af; ret`, where the
function returns an `int` in HL and DE is dead in fact.

That conservatism is shared by every DE-dependent rung here ([de-park],
[ldsi-addr], [ldhi-addr], this one), and lifting it needs what `xline_c_call`
did for BC: a way to tell, from the emitted text, which calls and returns
actually take DE. That is a bigger and more valuable lever than this rung, and
it is now the sweep's recommended successor — see `DESIGN_INDEX.md`.

Regression test `test/suites/long_ir/znadda.c`, six targets including
`_z80n_keep` (gate off) and z80/8080 controls. `djb2` and `addbyte` fire;
`carry_add` and `de_twice` must not change, and **the test says plainly that
those two are tripwires rather than live gates** — the widen pair in
`carry_add` is consumed by `ld hl,de; add hl,bc`, which never reaches the rung,
and `de_twice`'s twice-used byte takes a BC home. The guards themselves are
exercised by the corpus, not by the test file. Claiming otherwise is what went
wrong in ADR 0039 and again in ADR 0077.

## Refused in the same family

Two more z80n instructions were sized and **refused**:

* **`add hl,nn` / `add de,nn` / `add bc,nn`** (ED 34/35/36, 4 bytes, 16
  cycles). Against `ld de,K; add hl,de` — also 4 bytes, 21 cycles — this is
  **size-neutral** and 5 cycles faster, and it preserves DE. 145 sites, of
  which the DE preservation could only delete a park at **4**, all of them in
  one function (`md5`'s 88/89/90/91). One function's win is not a corpus win.
* **`push nn`** (ED 8A, 4 bytes, 23 cycles; the Rabbit 4000's ED A5 is the same
  4 bytes at 15). Against `ld hl,K; push hl` — 4 bytes, 21 cycles — it is
  size-neutral and 2 cycles **slower** on z80n. Its only merit is preserving
  HL, and the corpus does not want that: of 239 sites, 196 are immediately
  preceded by another `push hl`, HL is pure argument staging, and the number of
  HL park brackets around a constant push is **zero**. (The refusal rests on
  size and cycles only, so it is unaffected by `z80n_push_mn`'s operand order,
  which was the other way round in `src/ticks` when this was measured and has
  since been corrected upstream to match `opcodes.dat`'s big-endian `%M`.)
