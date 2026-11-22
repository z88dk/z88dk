# ADR 0046 — The A cache invalidates by default

Status: **Accepted**, default on. `IR_OFF=a-carry` opts out, byte-identical —
that path is also the regression test.

## Context

Widening the A-cache carry window (`a_cache_carry_safe`) is only safe with a
correctness partner: something that notices when an emitted line changes A.

## Decision

Invalidate at the `vemit` chokepoint on any line that value-changes A —
**invalidate by default** (Design C). A survives only across lines that
`instr_effects` *proves* preserve its value; an unrecognised (unknown) or
A-writing line drops `rs.a`.

The direction of the default is the whole point: an incomplete recogniser loses
**bytes, never correctness**. Any new instruction that nobody has taught the
recogniser about is conservatively assumed to clobber A.

## Consequences and the known cost

Default-on costs a few bytes at cold sites, with a flat tick delta.

The root is specific: caching A when it holds a pointer's low byte flips a
`ptr+K` lowering from `push de; ld de,K; add hl,de; pop de` (6 B) to an A-based
`add a,K; ld l,a; ld a,h; adc a,0; ld h,a` (7 B) — **+1 B and −16 T per site**, a
cold-path byte-for-tick trade the size work does not want.

The clean fix, deferred and not blocking: gate that A-based `+K` pointer lowering
to fire only when it does not grow bytes, after which this becomes a pure win.
