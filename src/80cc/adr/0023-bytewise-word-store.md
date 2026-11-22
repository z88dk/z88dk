# ADR 0023 — The bytewise word store

Status: Rejected (2026-09-01)

Relates to ADR 0002 (register model) and ADR 0016 (the belief cache).

## Context

In sp mode a word store through a pointer stages the value in a register pair,
which forces the base out of HL and costs a park and a restore. Walking the
store a byte at a time — read through HL, write through DE, value transiting A —
needs no pair at all.

In isolation the bytewise form is unambiguously better, assembled and counted
rather than estimated: it is the shortest of the three lowerings on every
supported CPU, including gbz80, where a two-byte register copy substitutes for
`ex de,hl` and the native post-increment load pays the difference back.

## Decision

Do not lower word stores bytewise. Built behind a gate and measured across the
corpus, every variant loses; the best-scoped one is break-even at best, and the
unrestricted form costs well over a kilobyte.

The reason is the part worth keeping, because it is not about this
transformation at all. **The pair-staging lowerings leave DE holding the value
just stored, and never invalidate that belief, so a later reader consumes it for
free.** The bytewise walk ends with DE holding the base plus an offset and A
clobbered, so it must *drop* the belief — and corpus-wide, the reloads that
follow cost almost exactly what the shorter store saves.

A local instruction-count comparison is therefore not sufficient evidence for a
lowering change. The belief the old form leaves behind is part of its cost, and
it is invisible to any measurement of the sequence in isolation.

## Reopening

Only with a lowering that preserves an equally useful belief — for instance one
that ends with DE still holding the stored value — or in a context where the
value is known dead afterwards. The isolated byte counts are already known and
do not need re-measuring; the belief accounting is the whole question.
