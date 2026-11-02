---
name: target-zx81
description: >
  z88dk +zx81 only: Sinclair ZX81. Classic clib, ixiy, -lm is genmath_zx81
  because the ROM interrupt does not save AF'. Use when the task is explicitly
  +zx81, not +zx or +lambda.
---

# Target — ZX81 (`+zx81`)

| | |
|--|--|
| Config | `lib/config/zx81.cfg` |
| Tree | classic `libsrc/target/zx81/`; CRT `lib/target/zx81/classic/` |
| Headers | `include/arch/zx81` |
| Wiki | `wiki/platforms/Platform---Sinclair-ZX81.md` |
| Help | `zcc +zx81 -h` |

Classic only. OPTIONS use `-mz80_ixiy` and `-clib=default` (`-lzx81_clib -lndos`).

## Maths

The ROM interrupt does not save AF'. math32 uses `ex af,af'`, so math32 cannot be the default here.

| Flag | Library |
|------|---------|
| `-lm` / `--genmath` | `genmath_zx81` |
| `-lmz` | ROM `m81` (`Z88MATHLIB`) |

Do not retarget `-lm` to math32. 6-byte and 8-byte reruns on other machines are in `library-math32`.

## Agent notes

1. Not `+zx` and not `+lambda`. Lambda shares this CRT file and `genmath_zx81`; its ROM `-lmz` name is different (`target-lambda`).
2. Related: `library-classic`, `library-math32`, `cpu-z80`.
