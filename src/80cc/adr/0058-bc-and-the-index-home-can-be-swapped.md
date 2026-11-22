# ADR 0058 — BC and the index home can be swapped

Status: **Accepted**, default on. `--opt-disable=home-swap` opts out.

## Context

The placement loop is an **isolation-priced greedy**: it walks candidates in
rank order, gives each its own best class, and whatever is left takes what
remains. It never prices the **pairing** — and for BC against an index home the
pairing is what matters, because the two registers are not interchangeable in
the same direction:

| | BC | IX/IY |
|---|---|---|
| a **value** | `ld a,c` — 1 B, 4 T | `push iy; pop hl` — 4 B, 25 T, and it cannot feed the ALU |
| a **base** | `ld a,(bc)` — 1 B, 7 T, **offset 0 only** | `(iy+d)` — 3 B, 19 T, at **any** offset |

So a pointer prefers BC only narrowly, while a value prefers it hugely — and the
greedy order hands BC to the pointer.

`bitfieldbench/reg_set`, z80 fp, by the arbiter's **own** benefit numbers:

```
v0 pointer   BC 226   IX 217
v1 value     BC 150   IX  65
greedy  v0->BC + v1->IY = 291
swapped v0->IY + v1->BC = 367      <- better by 76
```

xcc makes the swapped choice and needs **73 instructions** for `reg_set` where
80cc needed 136.

## Decision

Ask the question the loop never does. Deliberately narrow: **one** BC tenant and
**one** index tenant, both already placed, each admissible in the other's class,
and the swap must win on the same `interval_benefit` the loop ranked by.

## Note

This is a pairing correction, not a pricing one — the benefit numbers were
already right, and the greedy simply never compared the two assignments as a
pair. Worth remembering before reaching for a cost term: sometimes the model is
fine and the *search* is what is wrong.
