# ADR 0044 — A call argument qualifies a byte rematerialisation

Status: **Accepted**, default on. `IR_CALL_BREMAT=0` opts out, byte-identical.

## Context

`[IR_BYTE_REMAT]` re-issues `ld a,(sym)` for a global byte instead of spilling
and reloading it, when the load has a single qualifying use. A **call argument**
was not on the list of qualifying uses, and it should be: a byte argument is a
*terminal* consumer — the marshaller reads it once and pushes it — so re-issuing
the load at the push site costs the same 3 bytes as the slot reload it replaces,
and additionally drops the def's spill store and its slot.

The witness is `emu.c`'s `effective_string` family:
`return effective_ext(ptr, string_base_page, string_num_pages)` spilled both
globals to the frame purely to read them straight back one op later.

## Decision

Let a call argument be the single use that qualifies a global byte load.

Every byte-argument read path is remat-aware — `push_arg_byte_to_a` for a stacked
argument, `load_to_hl_adj`'s width-1 path for an sc1 register argument,
`load_byte_to_a` for a fastcall one. A path that is not aborts in `require_slot`
rather than reading an absent slot.

## Consequences

**The corpus does not contain the shape at all** (638 cells byte-identical either
way), so the evidence is `emu.c`: **−131 B fp / −272 B sp**. Gates: `long_ir`
650/650 sp+fp, `enigma` sp+fp, `emu.c` behavioural sp+fp.

## What was deliberately left out

Two other consumers were measured against this and buy nothing, so they are
**not** in the list:

* `IR_PUSH_ARG` — 0 B; pre-pushed arguments never carry the shape.
* `IR_RET` — 0 B; a returned global is already slotless.

Recording the negatives matters as much as the positive: without them the list
looks arbitrarily short and invites someone to widen it.
