# ADR 0104 — A constant byte return loads L directly

Status: **Accepted**, default on. `--opt-disable=byte-ret` opts out.

Draft PR https://github.com/z88dk/z88dk/pull/3174 already has an ADR 0104
for a different record. This number moves if that PR lands first.

## Context

A smallc function whose declared return is one byte hands that byte back
in L. Callers re-extend. H is not part of the value. The lowerer still
materialises a constant through A:

```
ld a,N
ld l,a
ret
```

`ld l,N` leaves L and H the same. It does not set A. sccz80's
`ld hl,N` / `ret` does not set A either.

`ld a,0` / `ld l,a` is not this rung. The xor-a pass rewrites the load,
and the flags from `xor a` stay.

The exit-path reload of a zero around a call is a different problem. The
middle argument overwrites HL, so the second `ld hl,0` is not a redundant
reload. That change stays refused.

## Decision

In the rendered-text pass, replace

```
ld a,N
ld l,a
```

with `ld l,N` when all of these hold:

* N is 1..255, written as a plain decimal immediate.
* A is dead after the pair on a straight-line walk: every follower
  ignores A or overwrites it, or the walk reaches an unconditional `ret`.
  A label, branch, call, or read of A refuses the fold.
* The two instructions are adjacent.

`ret` does not read A. An `__sdcccall(1)` byte return copies L back to A
with `ld a,l` before `ret`. That copy overwrites A from L, so dropping
the earlier copy in A leaves the same A at `ret`.

## Gate

`byte-ret`, default on. `test/suites/long_ir/byteret.c` runs on z80 and
8085, both frame modes, and with the gate off.

## Stage order (8/10/2026)

The fold first ran inside the peephole rung loop, before the xor-a rewrite.
That is before tail merging, and the narrowing makes constant returns differ:
three returns that ended in a shared `ld l,a; inc sp; pop iy; ret` each became
`ld l,N; inc sp; pop iy; ret`, the merge no longer paid, and `rpn.c` (sp) grew
by 2 B. The fold is now its own stage, `filter_byte_ret`, after tail merging
and before block layout. A merged site keeps `ld a,N` ahead of its `jp` because
the shared tail reads A; an unmerged site is narrowed as before. The `ld a,0`
case is unchanged: the xor-a rung runs earlier and the fold refuses 0.
Corpus result identical (the same 16 cells, -92 B), `rpn.c` back to 557 B.
`long_ir/retmerge.c` checks every constant path.
