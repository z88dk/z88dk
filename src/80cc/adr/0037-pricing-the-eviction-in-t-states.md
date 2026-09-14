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

What would actually move it is a model of what eviction *causes* — the packed
temps' BC reload traffic — and the way to get that is the project's own
proven pattern: a verifier first. Count emitted BC reloads per freed temp,
confirm the model against the `stencil` spread, and only then change a
decision.
