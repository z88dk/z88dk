---
name: target-zx
description: >
  z88dk +zx only: ZX Spectrum 48/128 (not Next). Classic default, newlib optional,
  -lndos stubs vs real FS (-lesxdos/-lp3), TAP/SNA/DOT packaging. Use when the
  task is explicitly +zx / Spectrum 48/128, not +zxn.
---

# Target — ZX Spectrum 48/128 (`+zx`)

| | |
|--|--|
| Config | `lib/config/zx.cfg` |
| Trees | classic `libsrc/target/zx/`; newlib `libsrc/newlib/target/zx/` |
| Headers | classic `include/arch/zx/`; newlib `_DEVELOPMENT/common` |
| Wiki | `wiki/platforms/Platform---Sinclair-ZX-Spectrum.md` |
| Help | `zcc +zx -h` |

## Not Next

| | **`+zx`** | **`+zxn`** |
|--|-----------|------------|
| Machine | 48/128 Spectrum | Spectrum Next |
| Default CLIB | classic **`default`** | newlib **`sdcc_iy`** |
| CPU in OPTIONS | Z80 | **`-mz80n`** |
| Appmake | `+zx` | `+zxn` (`.nex`, …) |

Do **not** copy Next subtypes (`nex`, `snx`, `dotn`) onto `+zx`.

## Defaults

| Item | Value |
|------|--------|
| CLIB | classic **`default`** → `-lzx_clib -lndos` |
| SUBTYPE | **`default`** → `-Cz+zx` |
| Math (classic native) | `Z88MATHLIB=mzx` / `__MATH_ZX` |

## Classic vs newlib

| World | Select | Notes |
|-------|--------|--------|
| Classic | omit / `-clib=default` / `ansi` / `noclib` | Main Spectrum path; examples under `examples/spectrum/` |
| Newlib | `-clib=new` / `sdcc_ix` / `sdcc_iy` | CRT `zx_crt.asm.m4`; `-lzx` |

**Disk:** classic default links **`-lndos`** (stubs). Real FS on the **command line**, searched first: **`-lesxdos`**, **`-lp3`**, **`-lzxmdv`**, **`-lzxbasdrv`**, … Never put `-lndos` before a real driver.

## Subtypes (packaging)

| Subtype | Role |
|---------|------|
| `default` | TAP-style via `+zx` |
| `wav` / `turbo` | audio loaders |
| `sna` | snapshot |
| `bin` | raw binary |
| `rom` / `if2` | ROM cartridge |
| `dot` / `dotx` | esxDOS DOT (`startupoffset` 0x100 / 0x200) |
| `plus3` | +3 loader pragma |
| `zxvgs` | ZX VGS packaging |

## Recipes

```text
zcc +zx -vn hi.c -o hi -create-app
zcc +zx -clib=ansi -create-app …
zcc +zx -lp3 -create-app …                    # real +3 FS
zcc +zx -clib=sdcc_iy -create-app …
zcc +zx -subtype=sna -create-app …
```

## Agent notes

1. Graphics / engines under `libsrc/target/zx/` (bifrost, nirvana, ulaplus, …) — match neighbour usage.  
2. Related: `cpu-z80`, `library-classic`, `library-newlib`, `tool-appmake`.
