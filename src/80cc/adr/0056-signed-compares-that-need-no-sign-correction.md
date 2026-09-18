# ADR 0056 — Signed compares that need no sign correction

Status: **Accepted**, default on. `IR_OFF=cmp-unsign` /
`--opt-disable=cmp-unsign` opts out.

## Context

A signed 16-bit compare lowers to `and a; sbc hl,de` plus **seven bytes of pure
sign correction** — `ld a,h; jp po,L; xor 0x80; L: rla` — because the carry out
of `sbc` is the *unsigned* answer and the signed one is S^V. When both operands
are provably non-negative the two answers coincide, so the unsigned kind
branches straight off that carry and the correction disappears.

## Measured before it was written

An inert `IR_CMPSIGN_PROBE` found **153** signed 16-bit compares over the corpus
plus the four real files, **50** of them provable = **350 B** in fp mode (adv_a
28 B, localbench 28, predbench 28, listbench 21…). Every site is a **loop exit
test**, so the correction also costs ~18–25 T per iteration — bytes and cycles
move together.

## Two things the probe corrected, both load-bearing

**`v_fits_byte` carries only 10 of the 50.** The other 40 are `i = i + 1`
induction variables, which that helper rejects (it takes only masked ANDs, small
constants, zero-extends and copies). Hence `v_nonneg_iv`.

**"every def is init >= 0 or += positive" is not a proof on its own.** A value
that only rises can pass 32767 and become negative:

```c
int i = 0; while (other) { if (i < 5) f(); i += 1; }
```

there the signed answer is true and the unsigned rewrite says false.
`cs_compare_bounds_loop` supplies the missing condition — the compare must be
the test that leaves the loop the step lives in. It **rejected 6 of the 56**
otherwise-passing sites, 2 of them in `adv_a`.

That second point is the general lesson: monotonicity is not boundedness, and a
"rising value" argument needs the loop exit to close it.
