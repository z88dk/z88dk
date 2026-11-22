# ADR 0088 — Indexed word RMW address restoration is a small rung

Status: **Sized**, no emitter change.

## Context

The indexed word read-modify-write path copies the computed address to BC,
reads the word through an advancing HL, increments the value, and rebuilds HL
from BC before storing it. The proposed lowerer shape reads the word into DE,
uses `dec hl` to restore the address after the second byte, and removes the BC
park and HL rebuild:

    ld e,(hl); inc hl; ld d,(hl); dec hl; inc de
    ld (hl),e; inc hl; ld (hl),d

The question was whether this shape occurs often enough in final assembly to
justify changing the emitter, and which readers leave HL recoverable as
address+1.

## Census

The census compiled the 30 source files in the indexed bench set for 12 CPU
variants and both SP and FP modes: 720 final assembly cells. It also compiled
`examples/console/adv_a.c` and `clisp.c` in Z80 SP and FP modes.

Reader classification was strict:

* A→HL: `ld a,(hl+); ld h,(hl); ld l,a`. HL no longer holds the address, so
  this reader must be changed to the DE form before `dec hl` can be used.
* DE: `ld e,(hl); inc hl; ld d,(hl)`. HL holds address+1 and is directly
  restorable with `dec hl`.
* BC and other readers were excluded when they did not leave the exact
  address-plus-one/store shape.

Only complete indexed word RMW sequences counted: address park, word read,
increment, address rebuild, and same-address word store. The result was one
site in `histbench.c`, present in these eight cells:

| CPU | SP | FP | bytes/site | total |
| --- | ---: | ---: | ---: | ---: |
| z80 | 1 | 1 | 5 | 10 |
| z80n | 1 | 1 | 5 | 10 |
| z180 | 1 | 1 | 5 | 10 |
| 8080 | 1 | 1 | 5 | 10 |
| **total** | **4** | **4** |  | **40** |

The remaining CPUs select another lowering, and the real files have no
eligible site. The 18 loose DE-reader matches in the broader scan were pointer
copies or slot/temporary traffic, not same-address indexed RMWs.

## Decision

Do not change the emitter from this census alone. The recoverable opportunity
is real but small: 8 measured cells and 40 bytes in total, all from the
benchmark deliberately written to expose this shape. Keep the result as the
baseline if a later lowerer change makes the DE reader available to more
indexed word RMWs.

The next density action is the commutative addition swap described in the
design index; it needs a two-pass spill cost model before implementation.
