# ADR 0036 — A parameter's register home pays for the frame it saves

Status: Accepted (2026-09-14)

Follows ADR 0035 (claims are priced in isolation) and ADR 0034 (one owner for
the allocation). Relates to ADR 0012 (frame-pointer default).

## Context

When the BC packer wants a register that a parameter already holds, it performs
an opportunity-cost comparison: the benefit of the tenants it would displace
against the benefit of what it could then place. That comparison is sound in
structure and it was getting the wrong answer.

The measured witness is `md5/MD5Init` in frame-pointer mode:

    generic:  evict=13  gain=20  -> EVICT
    grounded: evict=230 gain=390 -> EVICT

Both denominations agree, so it is not a units problem. Both under-price the
incumbent the same way, and for the same reason.

## What the model could not see

A parameter's slot is the **caller's** frame, and what it costs to read depends
on a decision the allocator does not make and cannot see:

| | a parameter read |
| --- | --- |
| framed | `ld hl,(ix+d)` — one instruction |
| frameless | `ld hl,N; add hl,sp; ld a,(hl+); ld h,(hl); ld l,a` — five |

The parameter in the witness is read six times.

Worse, evicting it does not merely make those reads dearer — it **flips the
mode**. `frameless_ok` requires every parameter to be homed in BC, so the
eviction costs the function its frameless form and the frame apparatus comes
back. Measured: `frameless` goes 1 to 0 across that decision.

`ir_alloc.c` contains no reference to framelessness at all. It is decided in the
lowerer, afterwards — and partly *because of* the allocation being scored.

## Decision

Charge a parameter eviction for what it actually costs.

When every parameter is currently BC-homed — the condition `frameless_ok` will
later test — evicting one of them adds two terms to the displaced benefit:

- **the dearer reads**: about four extra read-units per use, the difference
  between one instruction and five;
- **the frame apparatus** it brings back, priced as a handful of reads.

Both are expressed in the same `COST_*_W` units the comparison already uses, so
the two sides stay commensurable. The parameter rule of `frameless_ok` is a pure
function of the allocation, so the allocator can evaluate it locally without
calling into the lowerer or inverting the layering.

## Evidence

- **Size**: 30 benchmarks x 12 CPU variants x both frame modes, 720 cells —
  **−229 bytes, 9 cells smaller, NO cell larger.**
- **Ticks**: 11 CPU variants x both frame modes, 660 cells — **no cell slower,
  7 faster, no new failures.**
- The witness returns to its pre-regression size.
- `long_ir` 733/733 in both frame modes; enigma, clisp and emu.c unchanged.
- `IR_OFF=frameless-cost` is byte-identical to the compiler before the flip.

## Consequences

This does not resolve ADR 0035. It prices **one** term that was missing, in the
one place where the missing term was measurable. Narrowed home intervals
(ADR 0027) still leave 32 cells larger with this in place, down from 35 — so
other claims are still taken without their displacement being priced.

It is also a partial answer to the circularity. It works because the parameter
half of `frameless_ok` is computable from the allocation alone. A term that
depended on the *rest* of that predicate — or on any later lowering decision —
would still not be available here, and the structural fix the lowerer already
names (route every frame access through sp when frameless, so the mode is known
before allocation) remains the way to remove the dependency rather than
approximate it.
