# ADR 0066 — A home that is dear to fill cannot take a parameter

Status: **Accepted**.

## Context

`idx_ben` prices **accesses** and charges nothing for **filling** the home. For
most homes that is harmless. For a home that is expensive to fill it inverts the
answer.

A parameter has to be read out of the caller's slot and moved into the pair
before the home serves anything, and the pair is callee-saved across the whole
function. On the VM1's `h'l'` that is **44 T + 25 T + 21 T of setup against the
19 T a later read saves** — it wants five reads just to break even.

A **counter** pays back at once, because the home absorbs the **step** (35 T an
iteration) as well as the reads. `idx_ben` cannot tell the two apart.

## Decision

Reject parameter homes where the home is dear to fill.

Measured on the VM1: rejecting them is a win on **every** suite, in bytes *and*
ticks — charbench −34 B / −10168 T; −14 B each on queenbench, lexbench, sieve
and strbench.

## Scope, deliberately

The same argument applies to an IX/IY home, and `idx_ben`'s missing setup term
is already noted for the Rabbit. But changing that is a shared-codegen change
with its own gauntlet, so this gate asks about **this home** rather than about
the CPU. The general fix — a fill/setup term in the benefit model — remains
open.
