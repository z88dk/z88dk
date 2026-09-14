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

**Measured, it is not.** Across the corpus at 30 benches x 12 CPUs x both frame
modes: 73 cells smaller, **39 cells larger**, −508 bytes net, worst regression
+29 bytes on one file. So the premise is wrong somewhere, and finding out where
is the whole value of this step — see below.

Cache-only homes (HL, DEHL) and unhomed values are skipped; they are not
residency in the sense the table records.

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
