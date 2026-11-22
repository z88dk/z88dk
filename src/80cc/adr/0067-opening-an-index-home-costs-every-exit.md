# ADR 0067 — Opening an index home costs every exit

Status: **Accepted**.

## Context

Opening an IY home in a function that does not already own one costs `push iy`
in the prologue (2 B) and `pop iy` **at every exit** (2 B each).

Treating that as one-time holds for a single-exit function and fails badly
otherwise. `clisp`'s `l_read` has **six returns**, so the save costs
2 + 2×6 = **14 bytes** against the ~15 its single tenant saves at two use sites
— and the resulting growth then costs two `jr`→`jp` relaxations on top.

## Why the cost model cannot see it

`g0` is in **cycles**, where the save is ~29 per invocation no matter how many
exits exist. The **byte** cost scales with the exit count. This is a case where
the two axes genuinely diverge, and the cycle model is structurally blind to it.

## Decision

Charge the open against the tenants actually taken: each IY home removes about
one slot store + reload (~11 B in sp mode), so the k-th tenant is only worth
opening when `11*(k+1)` covers the save.
