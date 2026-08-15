---
name: target-rc2014
description: >
  z88dk +rc2014 only: modular RC2014 board target, default newlib sdcc_iy,
  classic vs 8085 serial subtypes (acia85/uart85), ROM/ihex packaging. Use when
  the task is explicitly +rc2014, not +cpm or +hbios.
---

# Target — RC2014 (`+rc2014`)

| | |
|--|--|
| Config | `lib/config/rc2014.cfg` |
| Tree | `libsrc/target/rc2014/` |
| Wiki | `wiki/platforms/Platform---RC2014.md` |
| External | RC2014 wiki “Using Z88DK”; local `wiki/external/RC2014-Using-Z88DK.md` |
| Help | `zcc +rc2014 -h` |

**Not** `+cpm` and **not** `+hbios` (separate cfgs). This is the modular RC2014 hardware family.

## Defaults (important)

Bare `zcc +rc2014 …` uses OPTIONS:

| Option | Default |
|--------|---------|
| CLIB | **`sdcc_iy`** (newlib) |
| SUBTYPE | **`basic`** |
| Defines | `__RC2014`, `__Z80` |

Classic Z80: **`-clib=default`**.  
8085 serial: subtypes **`acia85` / `uart85` / `basic85`** force **`-m8085 -clib=rc2014-8085`**.

## CLIB map

| CLIB | World | Notes |
|------|--------|--------|
| `default` | classic | `-lrc2014_clib -lndos` |
| `rc2014-8085` | classic 8085 | hybrid CRT path; `CLIB_DISABLE_FGETS_CURSOR=1` |
| `new` / `sdcc_ix` / `sdcc_iy` | newlib | CRT `rc2014_crt.asm.m4`, `-lrc2014` |

## Subtypes (from cfg)

| Subtype | Role |
|---------|------|
| `acia` / `sio` / `uart` | Serial CRTs (startup 0/4/8), ROM **ihex** |
| `acia85` / `uart85` / `basic85` | **8085** + `rc2014-8085` |
| `basic` | Default; `-D__BASIC` |
| `cpm` | CP/M-style startup on **this board** (still `+rc2014`, not `+cpm` host) |
| `none` | startup=256 |

Appmake is typically **`+rom` / ihex**, not CP/M disc images.

## Recipes

```text
zcc +rc2014 -vn hi.c -o hi -create-app                 # newlib, subtype=basic
zcc +rc2014 -clib=default -subtype=acia -create-app …
zcc +rc2014 -subtype=acia85 -create-app -vn hi.c -o hi # 8085
zcc +rc2014 -subtype=cpm -clib=sdcc_iy -create-app …
```

## Agent notes

1. Hybrid classic 8085 consoles: FILE flags / cook layer — see `library-classic`.  
2. Mixed multi-CPU trees: isolate via **lst**, not globs.  
3. Related: `cpu-8085`, `library-newlib`, `library-classic`.
