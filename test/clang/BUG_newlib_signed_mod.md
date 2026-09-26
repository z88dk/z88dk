# BUG: z88dk newlib returns |a % b| for 8/16-bit signed modulo (stale prebuilt library)

**Status: RESOLVED locally 2026-07-24 by rebuilding the newlib libraries** after
merging upstream/master. Root cause was confirmed exactly as diagnosed below —
stale prebuilt libs predating fix `af5630797c`. After
`make -C libsrc/newlib cpm-clean && make -C libsrc/newlib cpm`, signed 8/16-bit
`%` is C-correct on newlib for BOTH llvmz80 and stock sccz80 (`-30000 % 7 == -5`,
`-100 % 7 == -2`). The verification test `xfail_signed_mod.{c,sh}` now PASSES on
newlib (it stays as a regression guard / stale-lib detector). **Upstream action
still wanted:** the z88dk distribution's committed prebuilt newlib archives
should be regenerated so downstream users get the fix without a manual rebuild.

Found 2026-07-23 while adding clang/llvmz80 integer-helper support for the newlib
CP/M target; NOT a clang-specific issue — reproduces with stock z88dk sccz80 and
sdcc.

**Acceptance decision (user 2026-07-23):** treat this as a z88dk newlib bug;
matching z88dk's own newlib result is "good enough for now". The llvmz80
integer bridge (`libsrc/l/llvmz80/newlib/`) faithfully reproduces the library's
behaviour and must NOT paper over it — the fix belongs in z88dk newlib. Tracked
by the ignored test `test/clang/xfail_signed_mod.{c,sh}` (PASS on classic,
XFAIL on newlib).

## Summary

C requires `a % b` to take the sign of the **dividend** `a`
(ISO C `6.5.5`: `(a/b)*b + a%b == a`, division truncates toward zero). z88dk's
**newlib** library instead returns the **absolute value** `|a % b|` for 8-bit
and 16-bit signed modulo — the remainder-sign negation is dropped. The 32-bit
path and division (quotient) are correct.

## Minimal reproduction (no clang involved)

```c
#include <stdio.h>
volatile int a = -30000, b = 7;
int main(void){ printf("%d\n", a % b); return 0; }   /* C standard: -5 */
```

```
zcc +cpm -clib=default -o t -create-app t.c && ntvcm t.com   # sccz80 classic -> -5  (correct)
zcc +cpm -clib=new     -o t -create-app t.c && ntvcm t.com   # sccz80 newlib  -> +5  (WRONG)
```

Same compiler (sccz80), same source, **only the library differs** → it is a
library bug, not a compiler/language bug.

## Full evidence matrix — `-30000 % 7` (C standard: `-5`)

| compiler | `-clib=default` (classic) | newlib |
|----------|:-------------------------:|:------:|
| sccz80   | **-5** correct | **+5** WRONG (`-clib=new`) |
| sdcc     | **+5** WRONG   | **+5** WRONG (`-clib=sdcc_iy`) |
| llvmz80 (clang) | **-5** correct | **+5** WRONG (`-clib=newlib_iy`) |

Host `cc` confirms `-5`, `-2` (8-bit `-100%7`), `-4` (32-bit `-1000003%7`).

Per width, on newlib (all three compilers agree):

| width | expr | C | newlib |
|-------|------|:-:|:------:|
| 8-bit  | `-100 % 7`     | -2 | **+2** (at `-Os/-Oz`; `-O2` clang inlines → -2) |
| 16-bit | `-30000 % 7`   | -5 | **+5** (all opt levels) |
| 32-bit | `-1000003 % 7` | -4 | -4 (correct) |

Note sdcc is additionally wrong on **classic** too (its own `__modsint`
runtime), so the broken signed-remainder routine is shared beyond just newlib.

## Root cause — stale prebuilt newlib archives

The 16-bit signed-divide core source was **fixed upstream** in:

> **af5630797c** — "fix signed % remainder: l_small_divs jp m->call m
> (skipped remainder negation for -dividend/+divisor), sccz80 zmod_const routes
> signed %const to helper not |x|&mask, division suite to C99"
> — suborb (Dominic Morris), 2026-06-28, in `upstream/master`.

It changed `libsrc/math/integer/small/l_small_divs_16_16x16.asm` so the
remainder negation (`jp m` → `call m`) is no longer skipped for the
`-dividend / +divisor` case.

But the committed **prebuilt newlib archives** under `libsrc/newlib/lib/`
(sccz80 / sdcc_ix) were last regenerated **2026-03-26** (commit `948098a908`),
which **predates the 2026-06-28 fix by three months**. They still ship the old
buggy `l_small_divs_16_16x16`. The classic clib is assembled from the current
(fixed) source at build time, which is why classic is correct and newlib is not.

The 16-bit signed-divide source is confirmed correct in-tree today
(`; remainder takes sign of the dividend` … `call m, l_neg_...`).

## Suggested fix

Regenerate the prebuilt newlib libraries (`libsrc/newlib/lib/{sccz80,sdcc_ix}/`)
from current source so they pick up af5630797c. Also audit the 8-bit signed
`%` path (still `+2` on newlib at `-Os/-Oz`) — likely the same stale-archive
class, or an unfixed 8-bit sibling of the `l_small_divs` remainder-sign bug.

## Verification hook

`test/clang/xfail_signed_mod.{c,sh}` runs `-30000 % 7`:
- **PASS** if `-5` (C-correct — the classic clib path),
- **XFAIL** if `+5` (matches stock z88dk newlib — this known bug),
- **FAIL** if anything else (clang diverged from BOTH C and z88dk newlib).

Once the newlib libs are rebuilt, the newlib run should flip XFAIL → PASS and
the xfail note can be retired.
