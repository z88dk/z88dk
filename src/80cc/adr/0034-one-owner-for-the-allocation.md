# ADR 0034 — One owner for the allocation, and a rejection protocol

Status: Accepted (2026-09-14)

Amends ADR 0003 (register residency) and supports ADR 0017 (ranged residency),
which cannot be built safely while the plan has several writers.

## Context

The allocator produces a plan — which register holds which value, over which
interval, and whether a frame slot backs it. Four other places used to edit that
plan after it was produced:

- the lowerer assigned index-half homes after `ir_alloc` returned;
- the lowerer took the word-DE-home snapshot and `memcpy`'d it back to revert a
  pick;
- the lowerer demoted an unrealisable home in place;
- `ir_slots.c` re-derived the backing rules for itself.

Each is a way for the plan to be edited behind the allocator's back, and the
last one meant the question "does this value have a slot?" had two
implementations that had to agree.

## Decision

`ir_alloc` is the only writer of `vreg_to_phys`, `home_lo` and `home_hi`.
Everywhere else reads, through accessors.

**The render reports a rejection; the owner edits the plan.** A rejection names
a vreg and a reason. It never carries a replacement decision:

| Rejection | Call |
| --- | --- |
| a picked word DE-home formed no resident region | `ir_alloc_word_home_reject(f)` |
| a register home could not be realised | `ir_alloc_demote_home(f, v)` |

The snapshot the revert restores never leaves `ir_alloc.c`. Note that a revert
is deliberately **not** a re-arbitration: re-running allocation with the value
vetoed would re-place everything else too, which is a different decision and not
byte-identical.

Reads go through four questions, and the distinction between them matters:

| Question | Accessor |
| --- | --- |
| where is v homed AT THIS POINT | `ir_home_at_op(f, v, g)` (lowerer wrapper `ir_home_at`) |
| is v EVER homed in a register | `ir_home_assigned(f, v)` |
| does v need a frame slot | `ir_home_requires_slot(f, v)` |
| is v's home window ranged | `ir_home_is_ranged(f, v)` |

The point query takes its op index as an argument rather than reading lowerer
state, so allocation, slot assignment, the verifiers and a test can ask exactly
what the lowerer asks.

## Why this gates ranged residency

A point decision that reads the assignment directly ignores the home interval.
That is **inert while homes are whole-function, and a miscompile once they are
not** — so it must be fixed before ADR 0017's stages, not after.

Moving index-half assignment into `ir_alloc` also removed a latent defect of
exactly that kind: the re-arbitration retry re-runs `ir_alloc`, which rewrites
`vreg_to_phys` wholesale — silently erasing the index-half homes the lowerer had
assigned, with nothing to put them back. It was inert on the corpus, but only by
luck; it needed a function with both an unrealisable home and an index-half
candidate.

## Enforcement

`scripts/check_ownership.sh` fails on a direct write, a `memcpy` over the
arrays, or an indexed read outside `ir_alloc.c`. It was tested against a
deliberate bypass, and it found four bypasses that reading had missed — all of
them reads of the interval bounds rather than of `vreg_to_phys`.

`ir.c` is exempt: it owns the `Func` struct and dumps it raw, below `ir_alloc`.

## Consequences

One conversion was deliberately not made. The 27 direct reads became
`ir_home_assigned`, which ignores the interval — exactly what they did before,
so the change is byte-identical. Some of them are point decisions that *should*
honour the window; converting those changes emitted code for a call-split value
and is a measured decision per site, to be taken when ranged residency lands.
