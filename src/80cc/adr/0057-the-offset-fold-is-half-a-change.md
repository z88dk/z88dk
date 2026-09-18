# ADR 0057 — The offset fold is half a change

Status: **Accepted**, default on. `--opt-disable=deref-offset` opts out.

## Context

`t = p + K; *t` becomes `*(p + K)`. `MemOp` already carries base **and** offset,
so this is a pure rewrite rather than a representation change, and DCE reclaims
the `ADD` once the last deref through it has folded.

## It REGRESSES ALONE

Measured on its own it cost **z80 +77 B** (localbench +113). Dropping the
address temps lengthens the pointer's live range, and a nonzero offset on a
VREG base is re-formed with `ld de,K; add hl,de` at every access — so the
compiler pays for the offset as many times as it saved the add.

Its partner is the `idx-deref` lowering rung (`idx_deref_reg`), which turns
base+offset into a free `(iy+d)`. **The offset must be free for the fold to
pay, and it is free only when the base ends up in an index register.**

This is the clearest instance in the backend of a transform that is correct,
obviously beneficial in isolation, and negative until its partner exists.
Measure the pair.

## So the fold is aimed, not general

It fires only on the shape that can win the index home — the one
`idx2_home_realizable` admits:

* **a width-2 read-only pointer parameter.** A param has no def in this
  function, so `p` at the deref is provably the same value as at the `ADD` and
  the rewrite needs no dominance argument at all. Anything with a def could be
  redefined between the two (the IR is not SSA) and is **rejected rather than
  proved**.
* **never stepped.** A walking pointer wants HL/BC and regressed `strbench` when
  it was let into the index home; folding its offsets aims it at a home it
  should not have.
* **dereferenced at 2 or more sites, counted through the temps.** Before the
  fold a struct pointer reads as one direct deref plus N address temps — which
  is exactly the census that made the allocator pass it over.
* **every folded displacement inside the index byte** (−128..127, and d+1 for a
  word). An offset the rung cannot spell is an offset that goes back to being
  re-formed per access, i.e. the regression above.

CPUs with no index register — 808x, gbz80, and the VM1, whose idx2 is the
RS-prefixed `h'`/`l'` pair with no displaced form — can never collect the other
half, so the fold is skipped there outright.
