# ADR 0037 — Pricing the BC eviction in the arbiter's denomination

Status: **Rejected** (2026-09-14). Built behind a gate, measured on both axes,
withdrawn.

Follows ADR 0035, which asked for a realised-cost ledger, and ADR 0036, the
first refused attempt at one.

## The idea

`bc-evict` decides whether to displace a BC tenant by comparing two sums in
`cost_benefit[]` — a flat, register-agnostic, CPU-agnostic unit where every
access scores the same. The ranker already abandoned that unit for
`interval_benefit`, which prices an access by the g0 row for its CPU and
category (see `rank_benefit`). The eviction comparison was the last decision
still counting in the old unit, so bringing it into line would *remove* a cost
model rather than add one.

The mispricing is real and large. An `IR_LEDGER` sweep across the corpus, both
frame modes, found 89 eviction decisions. 64 have **no incumbent at all**
(`inc=0`) and are noise. Of the 25 real ones the two denominations disagree on
7 — always the same way, flat says keep and grounded says evict. The sharpest
case is `localbench/record`: the flat unit credits **nineteen** candidates a
combined gain of 6, exactly what it credits the single incumbent. Grounded, it
is 3348 against 111.

So the diagnosis was right. The fix still made the compiler worse.

## What it measured

Gate proven live and inert: 14 of 422 reference files change with it on, 0 with
it off.

**Size**, 720 cells (30 benches × 12 CPUs × sp/fp): **+2 bytes**, 38 smaller,
22 larger. Wins on the z80 family (z80 −23, z80n −27, z180 −22, r2ka −23),
losses on gbz80 +60, vm1 +30, kc160 +22.

**Ticks**, 132 cells over the six affected benches × 11 CPUs × sp/fp:
**+0.118 %**, 24 faster, **29 slower**.

A margin requirement — a crude stand-in for the BC reload churn the existing
comment already names as unmodelled — does not rescue it. Sweeping 100/125/150/
175/200/300 %, the best is 125 % at −16 bytes with 12 cells still larger and
ticks still net worse (+0.008 %, 9 faster, 22 slower). At 150 % and above
almost every flip is suppressed and the only survivor is a regression; at 300 %
the pass is inert.

## Why it fails, which is the part worth keeping

The flips split by **function**, not by CPU. `record` and `stencil` flipping
helps; `reg_set`, `udiv` and `multi_deref_one` flipping hurts. No threshold
separates them: `stencil` evicts at a 1.55× gain ratio and wins, `reg_set` at
1.51× and loses.

`matrixbench/stencil` then settles it. The **same** eviction, on the same
function, is **−6.2 % ticks on 8085** and **+12.5 % on z80 sp**. A more
accurate price for the accesses cannot produce that spread, because the accesses
are what the price describes. What varies is everything the eviction model does
not represent: what the freed BC is actually used for downstream, and the
reload traffic each freed temp brings with it.

So the eviction decision is not limited by the precision of its cost unit. Both
denominations are estimating the wrong quantity, and the flat one's coarseness
was, by accident, closer to a no-op — which is why it looked calibrated.

## Consequence for ADR 0035

ADR 0035's framing — "the ledger needs the opportunity cost of the claim it
displaces" — is now **too narrow to act on**. The opportunity cost is present
in `bc-evict`, in two denominations, and refining it has now failed twice
(ADR 0036 on the incumbent's side, this on both). A third attempt at a better
*price* should not be scheduled.

What would actually move it is not a better price for an access, but a model of
what the displaced value is **realised as**. Reading the `stencil` asm shows the
model assumes one realisation and the lowerer picks another:

* On **z80 sp**, the value the eviction displaces stops being a slot store
  (`ex de,hl; ld hl,4; add hl,sp; ld (hl),e; inc hl; ld (hl),d; ex de,hl`) and
  becomes a **stack park** (`push hl` / `pop de`) — 7 instructions down to 2,
  which is why the bytes fall. The park is also *cheaper* in cycles than the
  store it replaces (21 T against ~49 T), so the park is not itself the
  regression.
* On **8085**, the same eviction instead buys a genuine one-instruction register
  home — `ld bc,hl` / `ld hl,bc` replacing `ld de,sp+6` / `ld (de),hl`, using
  the 8085-only LDSI and LHLX/SHLX forms.

`GR_SLOT` describes none of these three things. The cost model prices a
displaced value as a frame slot; the lowerer realises it as a park, as a
chip-specific register form, or as a slot, and those have opposite byte and
cycle characteristics. That is the realised-cost gap ADR 0035 was reaching for,
located properly at last.

## What is NOT established

The z80 sp regression is **not** explained yet. Static counts move the wrong
way: gate-on has fewer sp-address sequences (30 against 33), barely more
push/pop (21 against 19), and is shorter overall, yet runs 12.5 % slower — and
only in sp mode, fp being unaffected. The cost is therefore dynamic and inside
the innermost loop, where the evicted tenant's reads become five-instruction
`ld hl,2; add hl,sp; ld a,(hl+); ld h,(hl); ld l,a` sequences that were register
moves before. This was read off the asm, not off a profiler; treat the
mechanism as probable, not proven.

## A separate defect this uncovered

The allocator prices **8085 as a z80** — it falls through to the default `Z80B`
byte row, with `penc == 0`, exactly like z80. But 8085 has LDSI and LHLX/SHLX,
which make a word slot access materially cheaper than the z80 sequence the row
describes, and it has no index register at all, so the fp sub-row (`(ix+d)`,
6/6/7/13) is fiction there.

This is why an 8085-only gate for the eviction was **not** taken even though
8085 is the one chip that wins on both axes (−14 B, −0.43 % ticks). The model
cannot see what makes 8085 different, so such a gate would encode the outcome
rather than the reason. Price the chip first; then re-ask the question.
