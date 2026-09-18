# ADR 0081 — On the ez80 a frame address is IX-relative

Status: **Accepted**, default on. `--opt-disable=lea-frame-addr` opts out.

Supersedes item 1 of ADR 0079, which called this refused.

## Context

ADR 0079 concluded that ez80's `lea` could not shorten the corpus's remaining
`ld hl,N; add hl,sp` pairs, because every `lea` form bases on IX or IY and
there is no SP-relative `lea`. The first half is true; the conclusion was
wrong, and the maintainer caught it:

**in fp mode the same address is reachable from IX, and the compiler knows the
offset.** `slot_ix_off` is `slot_off - f->frame_size`, and `cur_sp_adjust` — the
mid-function push shift — does not apply, because IX does not move. So
`lea hl,ix+d` (3 bytes, no flags written) replaces `ld hl,N; add hl,sp`
(4 bytes, writes carry) wherever the displacement fits a signed byte.

Two `emit_*_slot_addr` sites already did this. The remaining 196 fp-mode pairs
on ez80 classify as: **101 in plainly framed non-acc functions** (takeable),
66 in the prologue's own frame allocation, 22 in functions with no IX frame,
and 7 in `uses_acc` functions — where `fp_active` is deliberately false because
the wide-accumulator helpers **clobber IX**.

## Decision

One helper, `emit_frame_addr_hl(f, canon_off)`, carrying the lea-or-sp choice,
with the hand-rolled sites routed through it. `canon_off` is the `slot_off`
basis *without* `cur_sp_adjust`, which the helper adds for the sp form only.

`!L.cur_frameless` is load-bearing: `fp_active` returns **true** for a
frameless function, because frameless keeps fp-mode residency and only loses
the IX frame. An `(ix+d)` address there would be taken off the caller's frame
pointer. The helper also votes in `ds_ixaccess`, mirroring `slot_ix_off` —
emitting an IX-relative address is a reason to keep IX alive.

Converted: the word spill store (`ir_lower_analysis.inc.c`, 106 of the 118
takeable sites) and the in-place long shift (`ir_lower_cmp.inc.c`, 8). Sites
that hand-roll the sp pair with a **push offset of their own** are deliberately
left alone: that shift has no IX analogue. The prologue's own allocation is
also left — there IX has only just been loaded from SP, so its correct form is
`lea hl,ix-F` with no frame-size term at all, and an auto-pushed parameter can
sit between the two, which is a different rule and worth its own change.

**A copt rule had to move with it.** `#SP2` folds the second address of a
chained word store into a single `inc hl`, and it is keyed on the
`ld hl,N; add hl,sp` spelling. Emitting `lea` alone measured **−35 bytes with
8 cells LARGER**, because the fold stopped matching. `#SP2L` in
`lib/80cc_rules.1` is its `lea` analogue and also drops the intervening
`ex de,hl`, whose two halves are both overwritten by the lines that follow.
With it the same change is **−92 bytes and 0 larger**.

This is the per-addressing-form gap the `#G1`/`#S1`/`#S2`/`#R2` family keeps
producing (ADR 0075 said to look for more of them — this is one).

## Consequences

Measured on the ez80 cells of the size matrix, both frame modes:

* **−92 bytes**, 29 cells smaller, **0 larger**
* gate-off is **byte-identical to the pre-change compiler in all 60 ez80
  cells**, which also shows `#SP2L` is inert without the lowerer's `lea`
* `long_ir` all-pass in both frame modes; ez80 behavioural gates green in both
  (`enigma` RXSEC, `clisp` 6 then 42, `adv_a`)

Regression test `test/suites/long_ir/leafa.c`, six targets: ez80 in both frame
modes, an ez80 gate-off control, and z80/8080 which have no `lea` at all.
`init_pair` and `vm_loop` fire (3 and 4 sites); `big_frame` carries **both**
sides of the range guard — its word local is in displacement range and takes
`lea`, its 80-word array is far outside and keeps the sp form; `by_ptr` must
not change.

**The first version of that test fired only in the function meant to be the
out-of-range control**, because the shape that converts is a run of word locals
*spilled to slots* — their initialisation at function entry, as in
`switchbench`'s `vm_run` — and four plain locals in a small function never
reach a slot. Third time in this family that a codegen test needed the
per-function asm diff before it could be believed.

Writing that test also turned up **a pre-existing miscompile unrelated to this
rung** — see ADR 0082. The `init_pair` shape failed on the *baseline*
compiler.
