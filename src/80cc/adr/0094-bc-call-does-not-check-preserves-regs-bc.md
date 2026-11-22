# ADR 0094 — `[bc-call]` ignores `__preserves_regs(b,c)`, and it is currently harmless

Status: **Accepted** (no code change). Closes the "next action" left open by
ADR 0084 and DESIGN_INDEX.md.

## Context

ADR 0084 fixed the same shape of over-claim for DE (`[de-call]`: not every
`call` reads/clobbers DE) and left a note for whoever read `[bc-call]` next:
it kills BC at any `call _sym` on the argument ABI alone, and never asks
whether the callee is declared `__preserves_regs(b,c)`.

Unlike DE's `__preserves_regs(d,e)` — which ADR 0084 found **inert**, "no C
definition in this tree honours it" — `__preserves_regs(b,c)` is not
hypothetical here. It is declared on real, commonly-called functions:

* `ctype.h`'s `CTYPE_PRESERVE` macro, applied to every `is*`/`to*` fastcall
  variant (`isalpha_fastcall`, `isdigit_fastcall`, `toupper_fastcall`, …) —
  `__preserves_regs(b,c,d,e,iyl,iyh)` off gbz80, `__preserves_regs(b,c)` on it;
* `intrinsic.h`: `intrinsic_swap_endian_32(_fastcall)`, `intrinsic_ex_de_hl`,
  `intrinsic_swap_word_32(_fastcall)`, several `intrinsic_label`/`intrinsic_emit_*` helpers;
* `string.h`: `ffsll` / `ffsll_callee`.

And the allocator side honours it for real: `gen_call` in
`ir_lower_call.inc.c:67-95` computes `bc_preserved = (ci->preserved &
IR_R_BC) != 0` (fed by `preserve_to_regmask`, `ir_build.c:406`, off the
parsed `__preserves_regs` attribute, `declparse.c:646`) and skips the
`push bc` / `pop bc` guard around the call when it holds — a PR_BC-homed
value is left resident in BC across such a call with no save at all.
Verified directly: a function with two live sums (one homed in BC, `ld
c,a`/`ld b,a`) that calls a fastcall function declared
`__preserves_regs(b,c)` emits the call with **no** `push bc`/`pop bc`, and
`add hl,bc` after the call reads the pre-call value correctly.

## The check

Does `[bc-call]`'s blindness to `__preserves_regs(b,c)` cause `filter_dead_bc_parks`
(the backward BC-liveness sweep in `ir_lower.c` that treats every `call _sym`
as "BC dead above this point") to delete something that is actually live
across a preserving call?

Only two things in that sweep can delete code from this liveness:

1. **The `ld bc,hl` park drop** (`ir_lower.c:2517-2519`): drops a literal
   `ld bc,hl` when neither B nor C is live afterward. `e.park` is set **only**
   by that exact text (`ir_lower.c:4423`) — a paired-register write from HL,
   never the single-register `ld b,...`/`ld c,...` writes a normal PR_BC vreg
   home uses (confirmed above: those aren't `e.park`, so this drop cannot
   touch a PR_BC-preserved home at all).
2. **`[idx-rmw-de]`** (`ir_lower.c:2369-2383`, ADR 0093): requires an *exact*
   10-line adjacent `strcmp` match with its own `ld bc,hl`/`ld hl,bc` at both
   ends. A `call` between them breaks the match by construction, so it cannot
   fire across one.

So the only live question is (1): does any `ld bc,hl` park in the tree sit
before a `call _sym` with its restore/read after the call, and nothing else
touching B/C in between? Every emission site was read:

* `ir_lower.c:801` (`emit_hl_to_bc`), `:5417` (long-return stack reclaim) —
  both immediately restored 2-4 lines later, no call between.
* `ir_lower_call.inc.c:391,398` (`SHORTCALL_HL` / `HL_CALL`) — precede an
  `rst` or a **numeric** `call N`, never a `call _sym`; `xline_c_call`
  doesn't match either, so `[bc-call]` never even fires here.
* `ir_lower_regcache.inc.c` (the DEHL-cache invariant, ~10 sites) — the
  `ld bc,hl` publishes "BC = low half of the resident long", consumed by
  `load_to_dehl_adj`'s `ld hl,bc` recovery. Every site is inside one
  operator's straight-line lowering; none straddles a call.
* `ir_lower_ops.inc.c:1475,4960` — same DEHL-cache pattern, same locality.

No site parks BC across a call today. `[bc-call]` therefore has a rule gap, but
it causes no bug because no current code asks BC to survive a call this way.

## Decision

No code change. `[bc-call]` stays as-is. This differs from ADR 0084's DE case:
`__preserves_regs(b,c)` is **used** in this tree. `ctype.h` alone puts it on a dozen
frequently-called functions) — only the specific `ld bc,hl` park idiom never
crosses a call boundary yet. A future rung that stashes a BC-resident value
*across* a call (the shape `[de-call]` already solved for DE: prove-clean by
symbol, `xf_decall`-style, keyed off `ci->preserved & IR_R_BC` this time
rather than the DE argument ABI) must not reuse `[bc-call]`'s "any call to
compiled C kills BC" rule unchanged — it would need the same
prove-clean-by-symbol treatment `[de-call]` has, not a text-only fix.

## Consequence for the allocator work this was gating

DESIGN_INDEX.md's "Next action" held allocator work on `__preserves_regs(b,c)`
back until this was checked. It is checked: there is no correctness bug to
fix, and no byte to recover either (no park crosses a call to gate). The
allocator's existing `bc_preserved` skip in `gen_call` already captures the
whole benefit `__preserves_regs(b,c)` can offer today. This issue is closed.
remove it from DESIGN_INDEX.md's next action.
