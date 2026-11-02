---
name: target-lambda
description: >
  z88dk +lambda only: Lambda 8300. Classic clib, ixiy, -lm is genmath_zx81
  because the ROM interrupt does not save AF'. Use when the task is explicitly
  +lambda, not +zx81 or +zx.
---

# Target — Lambda 8300 (`+lambda`)

| | |
|--|--|
| Config | `lib/config/lambda.cfg` |
| Tree | classic `lib/target/lambda/`; startup asm is the ZX81 CRT |
| Wiki | `wiki/platforms/Platform---Lambda.md` |
| Help | `zcc +lambda -h` |

Classic only. OPTIONS use `-mz80_ixiy` and `-clib=default` (`-llambda_clib -lndos`). Subtypes include `default`, `fast`, `mono`, `monofast`, `cac3`, and `cac3fast`. Packaging is `+zx81 --lambda`.

## Maths

Same ROM interrupt as the ZX81: AF' is not saved. math32 uses `ex af,af'`, so math32 cannot be the default here.

| Flag | Library |
|------|---------|
| `-lm` / `--genmath` | `genmath_zx81` |
| `-lmz` | ROM `mlambda_tiny` (`Z88MATHLIB`) |

`-lmlambda` remains the larger ROM name. Do not retarget `-lm` to math32, and do not replace `-lmz` with `-lmlambda`.

## Agent notes

1. Not `+zx81`. The shared float exception is the same; the ROM library name is not (`target-zx81` uses `m81`).
2. Related: `library-classic`, `library-math32`, `cpu-z80`.
