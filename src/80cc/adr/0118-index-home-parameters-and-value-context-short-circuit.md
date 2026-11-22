# ADR 0118 — Index-home parameters, `&&`/`||` as values, and side-exit beliefs

Status: **Accepted** (2026-10). Opt-outs: `cond-value`, `side-exit-carry`.

## Context

PR 3181 added `cmpbench` (relational operators and `&&` used as values) and
reported two things: 80cc Z80 returned 4 instead of 3 for a function holding a
run of `&&` chains and six signed relations, and 80cc's code for the chains was
twice sccz80's (Z80 `arms()` 1581 B against 801 B).

## Decision

- **Parameters and the spare index register.** The allocator may share the spare
  index register (IX, or IY in frame-pointer mode) between values whose live
  ranges do not overlap (`idx2-reuse`). A parameter is loaded into its home in
  the prologue whatever window was proved for it, so two parameters shared IX and
  the second load overwrote the first before its last use (`p` and `a` in
  `f(p, rc, a, b, c)`). A parameter now takes the home only as its first
  occupant, and later occupants must start after it ends. `idx2_live_free_p`.
  Test: `long_ir/idx2param.c`.
- **`a && b` and `a || b` as values** branch each leg straight to a join that
  writes 0 or 1, the form conditions already used, instead of turning every leg
  into a stored boolean merged through a multi-def vreg and tested again.
  `cmpbench` object: Z80 2071 -> 1247 B (sccz80 1245), frame pointer 1811 -> 1190
  B, 8085 2167 -> 1284 B (sccz80 1463). Test: `long_ir/condvalue.c`.
- **Side-exit beliefs.** The new shape put several conditional exits in one
  block, and the HL slot address HL held at the end of the block was handed to a
  successor reached from an earlier exit, where HL held another address
  (`a && b` testing `a` through one address and `b` through the next). The
  lowerer now records the HL, A, BC, DE and slot-address beliefs at each
  conditional side exit and marks the edge unsafe where they differ from the
  end-of-block state. Only that edge loses the carry; the fall-through
  successor keeps it, so no size is lost (`side-exit-carry`). A coarser
  per-block version cost `strbench` +8 B and was replaced.

## Result

Corpus size and tick scans are unchanged against the previous sweep (the bench
corpus has no value-context chains). long_ir 1611/1611 in both frame modes,
suites rc 0. `cmpbench` passes on all 12 CPU targets. The sccz80 faults found
with it are in the same commit series: `docast` now always masks a folded
constant to the cast type (`(unsigned char)(0xFF + 1)` held 256), and the Rabbit
`ld hl,0` -> `bool hl; rr hl` size rule waits for the next instruction and does
not fire before one that reads flags (`suites/sccz80/compare_castconst.c`).

## Left

- A value-context chain still ends in `ld bc,1 / jp / ld bc,0`; the chain feeding
  `n += ...` could be an `inc` at the true arm.
- The same multi-exit assumption may hold for other per-block records
  (`bb_byte_out`, the lazy-spill pending set); only the register beliefs were
  audited.
