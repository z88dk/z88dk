# ADR 0069 — A bare `pop hl` clears the address belief

Status: **Accepted**. A correctness rule, not an optimisation.

## The rule

A bare `pop hl` restores an HL that some emitter pushed to **preserve** it across
a region. Whatever address belief the region established inside itself is
discarded by the pop — HL now holds the pushed value again — and nothing
restores the belief that was live before the push.

Clearing is the safe approximation: it can only cost a recompute, never read a
bogus pointer.

## What it fixed

This is what the vm1 `maskbench` / `queenbench` / `searchbench` **wrong answers**
were. A word load into DE published "HL = &slot+1" **inside** a caller's
push/pop preserve region; the pop put a data value back in HL; the stale belief
then rode the cross-BB carry into a branch target and became `dec hl` on garbage.

Callers that genuinely keep an address in HL re-establish it right after the pop,
so the conservative clear costs little.

## The general shape

A belief published inside a preserve region does not survive the region. Any
future cache that publishes across a push/pop pair needs the same rule — which
is why it is recorded as a rule rather than as a bug fix.
