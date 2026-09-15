# ADR 0072 — The commutative swap in addition is refused

Status: **Rejected**. Not built; `gen_bitop`'s equivalent stays.

## The idea

`gen_bitop` has a commutative swap and addition is equally commutative. Swapping
so the DEHL-resident operand stays put and the other is read from its slot
*looks* free — and `md5` gained **6 % of its cycles**.

## Why it is refused

Reading a slot in **pass 1** of the lazy spill makes that slot's store **live in
pass 2**, resurrecting a store the previous op had elided.

Where the memory operand really is in memory (`md5`'s `x[]`) that costs nothing.
Where it is a fresh value that would never otherwise reach memory —
`binary-trees`' `ItemCheck`, whose operand is a call result — it adds a store
**and** a reload:

| | effect |
|---|---|
| `md5` | −6 % ticks |
| `binary-trees` | **+0.39 % ticks and +28 bytes** |
| `emu.c` | **+75 bytes** |

## What it would take

Gating it needs a **cost model over the two-pass spill decision**, not a
residency test. The question is not "where does this operand live" but "will
reading it here resurrect a store the other pass elided" — and nothing in the
allocator can answer that today.

Recorded so the next person who notices the missing swap in addition does not
have to rediscover the two-pass interaction.
