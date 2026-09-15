# ADR 0027 — Truthful home intervals

Status: Proposed, **in flight** — stage 1 of ADR 0017's ranging arc, staged
behind `IR_TIGHT_HOMES`. Not an independent lever: stage 2 cannot begin until
the intervals are truthful.

Builds on ADR 0017 (ranged residency as a home-per-interval table). This is the
first step of it, and the prerequisite for every later one.

## Context

The home table already carries an interval per vreg, `[home_lo, home_hi]`, but
allocation fills it with the whole function. A home is therefore *assigned*
over a range far wider than the value is live, and the interval carries no
information: every point query inside it answers the same as the raw
assignment.

That is why the interval is currently harmless and also useless. Nothing can
time-share a register over a disjoint sub-range, and the range-aware verifier
has no real window to check against.

## Decision

Narrow each home to the value's true live range.

The reasoning said this must be **byte-identical**: a vreg is only accessed
within its live range, where its home is unchanged, so narrowing cannot alter
any access the compiler is supposed to make.

**Measured, it is not** — and re-measured on 2026-09-15, after the static
DE-clean point fix, the corpus at 30 benches x 12 CPUs x both frame modes gave
58 cells smaller, **35 larger**, −190 bytes net, worst +29.

## The failure has TWO causes, not one (2026-09-15)

An `IR_HOMEMAP` register-class census separates them, and only the first matches
the diagnosis this file previously carried:

**A. The allocator takes newly-visible claims.** `md5` z80-fp (+29): register
homes 221 → 226, five ALLOCMAP rows differ.

**B. The allocation is bit-for-bit identical and the code still grows.**
`shiftbench` 8085 (+14), `callbench` z80-fp (+7): zero ALLOCMAP rows differ.

Class B was assumed to be the "invisible residency" hazard below — a lowerer
access outside the IR live range. **Most of it was not.** It was a predicate
that cannot tell narrowing from splitting:

```c
int ir_home_is_ranged(...)  /* true for ANY window that is not whole-function */
frameless_ok():  if (ir_home_is_ranged(f, v)) return 0;   /* ...so: every param */
```

`IR_TIGHT_HOMES` narrows every home to its live range, so every home became
"ranged", `frameless_ok` rejected every parameter, and frameless functions grew
a frame — visible in the asm as `push ix; ld ix,0; add ix,sp` replacing
sp-relative addressing. On `callbench`, 0 of 67 ALLOCMAP rows had a
non-whole-function window before, 11 of 67 after.

The rejection is **false**. A ranged home is dangerous because outside its span
the value is *slotted*, so an access there reaches memory. Under tight homes the
span IS the live range — outside it the value is *dead*, and there is no access.

**Fixed** by `ir_home_covers_live_range()`, which asks whether the window covers
the live range rather than whether it is literally whole-function, at the two
callers that wanted the narrower question (`frameless_ok` and the dead-frame
trustability test). Default path unchanged: **720 of 720 cells byte-identical**,
reference 422/422, `long_ir` 739/739 both modes, enigma and clisp green.

With that fixed, `IR_TIGHT_HOMES` now measures **58 smaller, 24 larger, −331
net** (from 35 larger, −190).

## The residual cells were a LATENT MISCOMPILE (2026-09-15)

Tracing the worst one, `shiftbench` on 8085 (+14), the byte walks replacing LHLX
were not a lowering preference at all. `load_to_hl_adj` was reached 46 times
with the gate off and only 26 with it on — the caller had stopped routing
through it, because a home query answered differently.

`shift_compute v3`: `phys=BC`, window **`[12,36]`** with the gate off, live range
`[1,75]`. With the gate on the window became **`[1,75]`**. The step **widened**
it.

`[12,36]` is a call-split home. Its window is deliberately narrow *because the
value is slotted outside it*. Widening the window to the live range makes the
lowerer believe BC holds `v3` over `[1,11]` and `[37,75]`, where it does not —
a false residency belief, which is a miscompile waiting for a lowering path that
trusts it. It surfaced as +14 bytes only because the path that ran happened to
reload from the slot anyway.

The cause is that the step **assigned** where it should have **clamped**:

```c
f->home_lo[v] = lr->start;   f->home_hi[v] = lr->end;      /* wrong */
if (lr->start > f->home_lo[v]) f->home_lo[v] = lr->start;  /* narrow only */
if (lr->end   < f->home_hi[v]) f->home_hi[v] = lr->end;
```

This file always said "narrow whole-function homes"; the code never checked that
the home *was* whole-function.

## Measured after both fixes

720 cells (30 benches x 12 CPUs x both frame modes): **20 smaller, ZERO larger,
−136 bytes net.** The premise this ADR opened with — that narrowing must be
byte-clean — now holds, and narrowing is slightly *better* than whole-function
homes because the point queries it feeds are more accurate.

Gates with `IR_TIGHT_HOMES=1`: `long_ir` 739/739 both frame modes, enigma
`RXSEC` both modes, clisp `6`/`42`, z80 corpus ticks **+0.0000 %** with 0 cells
slower and 60/60 `fail=0`. Default path (gate off) unchanged: reference 422/422,
720/720 cells byte-identical.

**Stage 1 is therefore complete and the gate is ready to flip default-on**,
which unblocks stages 2 and 3 of ADR 0017.

## Why it is worth doing before anything ranged

A byte difference after narrowing is not a regression to be tuned away — it is
**the discovery of a lowerer access outside the IR live range**. That is the
"invisible residency" hazard: a read the liveness model does not know about,
which is harmless while every home spans the whole function and becomes a
miscompile the moment a register is time-shared.

So this step converts a latent, untestable hazard into a visible byte diff,
before any feature depends on the interval being true. It also gives the
interval verifier a real window instead of a tautology.

## Investigated 2026-09-14 — the answer is (2), with two instances of (1)

The two possibilities above have been separated, and the feared one is small.

**It is not systemic invisible residency.** Instrumenting the window test and
running the corpus (30 benches x both frame modes) with narrowing on gives
**two distinct rejection sites**, `hashbench/hash_key v9` and
`structbench/walk v2` — and both are at flat index **0**, before the value's
live range begins (`v9` is a local, defined by a `MOV` at op 2). So nothing is
reading a value *after* it dies; something is asking a **whole-function question
through the point query** at op 0. That is a query-discipline defect of the kind
ADR 0034 names, it is two sites, and it is fixable on its own.

**The regression is allocation change.** With truthful intervals the packers and
the arbiter see short call-free intervals they could not see before, and they
take them. The clearest case is `md5/MD5Init` in fp: `ir_bc_pack` moves BC off
the parameter — six dereferences — onto two address temporaries with one use
each, and each of the six then costs a five-instruction slot reload. Disabling
`bc-pack` collapses that cell from +29 bytes to +3.

But `bc-pack` is **not** the general cause: with it disabled on both sides the
corpus still has **36 of the 39** larger cells. Different mechanisms, same
shape — a claim taken because it now looks admissible, without anything pricing
what it displaces.

That is ADR 0035 reproduced exactly: a more truthful input makes the output
worse while claims are scored in isolation.

## Consequence for sequencing

**This step is blocked on the realised-cost ledger, not the other way round.**
The index previously listed it first on the theory that it might be a latent
miscompile; it is not, so it should follow the ledger. Narrowing is worth
−508 bytes overall and it makes the interval mean something — but it cannot land
while every newly-visible claim is taken on an isolated score.

Do first, independently of the ledger: fix the two point-query misuses, since
they are a defect today and would be a miscompile under ranging.

## Acceptance

The original bar was byte-identical across the corpus, every CPU variant and
both frame modes, with any differing cell investigated as an invisible-residency
finding. That bar is **not met**, and thedifference is not noise — 112 cells move.

So the step cannot land as written. Before it does, the differing cells have to
be explained. There were two possibilities (the investigation above settles
which):

1. the lowerer really does access a value outside its IR live range (the
   invisible-residency hazard — a latent miscompile waiting for ranged
   residency), or
2. the narrowed interval changes an allocation decision downstream, in which
   case this is not the neutral substrate step it was meant to be, and it needs
   its own size and tick case like any optimisation.

Start with the worst cell (`md5`, +29 bytes, every CPU, fp mode) — it reproduces
identically across CPUs, which points at decision change rather than a
CPU-specific access.
