# ADR 0027 — Truthful home intervals

Status: Proposed (staged behind `IR_TIGHT_HOMES`)

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

This is expected to be **byte-identical**, and that expectation is the point: a
vreg is only accessed within its live range, where its home is unchanged. So
the narrowing cannot alter any access that the compiler is supposed to make.

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

## Acceptance

Byte-identical across the corpus, every CPU variant, both frame modes. Any cell
that differs is investigated as an invisible-residency finding and explained
before the step lands — never absorbed as noise.
