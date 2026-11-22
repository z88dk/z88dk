# ADR 0092 — A masked shift in a loop gives up the top-byte route

Status: **Accepted** (2026-09-17). Opt out with `shr-tbac`.

## Context

`(x >> n) & M` with M inside one byte has two lowerings. The **top-byte** route
aligns the field upward and reads the high byte: `add hl,hl × (8-n)` then
`ld a,h`. The **A-chain** (ADR 0090) shifts right through A: `ld a,l` then
`srl h; rra` × n.

ADR 0090 set out to replace the top-byte route and did not: the top-byte branch
is chosen first in `gen_shr`, so the A-chain only ever saw full-width shifts.
Its intended site — `histbench`'s `bins[(seed >> 3) & BMASK]++` — was never
reached. This ADR is that missing half.

## The two curves cross

Counted from a common start, with the value in a frame slot so the load's
`ld l,a` is live for the top-byte route and dies to `shr-dead-l` (ADR 0091) in
front of the chain:

| n | top-byte B/T | A-chain B/T | delta |
| --- | --- | --- | --- |
| 2 | 8 / 74 | 6 / 24 | **−2 B, −50 T** — both axes |
| 3 | 7 / 63 | 9 / 36 | **+2 B, −27 T** — a trade |
| 4 | 6 / 52 | 12 / 48 | +6 B, −4 T — not worth it |
| 5..7 | 5..3 / 41..19 | 15..21 / 60..84 | worse on both |

`add hl,hl` gets CHEAPER as n grows while the chain gets dearer, so the curves
cross at n==4 and never come back. This is why the rung is bounded above rather
than applied to the whole 2..7 range the top-byte route covers.

The saving depends on the source arriving through A from a slot. A source
already in HL has no `ld l,a` to cancel, which costs the chain 2 bytes and
makes n==3 `+4 B for −19 T`. That is the case `histbench` actually hits.

## Decision

Take the A-chain when n==2 unconditionally, and when n==3 **only inside a
loop**. Leave n>=4 alone.

The loop gate is what makes n==3 defensible: +4 bytes buys −19 T *per
iteration*, so the cost is paid once and recovered every time round. In
straight-line code the same trade is a pure loss, and `cold3` in the regression
test pins that.

## Which CPUs — the trade INVERTS on two of them

Enabled on **z80, z180 and gbz80 only**. This is deliberately NOT the
`cb_shift_cpu()` set that ADR 0090 uses. The chain being cheaper in BYTES is
CPU-independent, but this rung *spends* bytes to buy ticks, so it also needs
the tick side to hold — and it does not everywhere:

| CPU | histbench | predbench | |
| --- | --- | --- | --- |
| z180 | **−4.202 %** | −1.000 % | enabled |
| z80 | **−2.968 %** | −0.692 % | enabled |
| gbz80 | −0.618 % | −0.135 % | enabled, marginal |
| ez80 | **+2.438 %** | +0.644 % | **EXCLUDED — slower** |
| kc160 | **+4.632 %** | +0.900 % | **EXCLUDED — slower** |

All ten cells cost the same +4 bytes. On ez80 and kc160 `add hl,hl` is about a
cycle while the CB ops carry prefix cost, so five shifts beat three
`srl h; rra` pairs and the rung is a pure loss — bytes spent, ticks lost.

An aggregate over the five CPUs would have hidden this behind z80 and z180 and
shipped a regression on two targets. Report per CPU; never average a trade.

gbz80 is kept but is marginal: −0.618 % for +4 bytes is the weakest cell that
stays in. If a future scan finds it negative, drop it without ceremony.

## Measurement

15 likely benches A/B'd. **Two move:** histbench and predbench; the other
thirteen — callbench, bitfieldbench, crcbench, fixedbench, localbench, md5,
widthbench, maskbench, lexbench, hashbench, interpbench, divbench, shiftbench —
are byte- and tick-identical. (crcbench and localbench run to a tick cap, so
their totals are limit-bound either way.)

Over the 720-cell corpus the whole shift arc (this rung + ADR 0090's widening +
ADR 0091) is **−148 bytes, 43 cells smaller, 12 larger**. The 12 larger are
exactly histbench and predbench on the three enabled CPUs in both frame modes,
at +4 bytes each — the trade, in full view and nowhere else.

Regression target `test/suites/long_ir/shrtbac.c`, five variants (sp, fp, keep,
gbz80, 8080). It carries `cold3` (same expression, no loop — must NOT change)
and `deep4` (n==4, past the crossover — must NOT change) alongside the two
shapes that must.
