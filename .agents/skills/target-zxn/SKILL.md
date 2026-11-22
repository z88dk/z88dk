---
name: target-zxn
description: >
  z88dk +zxn only: ZX Spectrum Next. Default -mz80n and newlib sdcc_iy,
  classic via -clib=classic, NEX/DOT packaging, nextreg/copper via cpu-z80n.
  Use when the task is explicitly +zxn / Next, not +zx.
---

# Target — ZX Spectrum Next (`+zxn`)

| | |
|--|--|
| Config | `lib/config/zxn.cfg` |
| Trees | `libsrc/target/zxn/`, `libsrc/newlib/target/zxn/`, `examples/zxn/` |
| Headers | `include/arch/zxn.h` (nextreg, copper, MMU, …) |
| Wiki | `wiki/platforms/Platform---ZX-Spectrum-Next-zxn.md` |
| CPU skill | **`cpu-z80n`** (Next opcodes, nextreg, copper) |
| Help | `zcc +zxn -h` |

## Not 48/128 (`+zx`)

Bare `+zxn` is **Next**. Do not use `zx_clib`, `+zx` subtypes, or Spectrum-only recipes.

## Defaults (critical)

| Option | Default in `zxn.cfg` |
|--------|----------------------|
| CPU | **`-mz80n`** |
| CLIB | **`sdcc_iy`** (newlib + reserve IY) |
| SUBTYPE | **`default`** → appmake **`+zxn`** |
| Defines | `__ZXNEXT`, `__Z80N`, … |

So bare `zcc +zxn …` is **newlib**, not classic.

## CLIB map

| CLIB | World | Notes |
|------|--------|--------|
| **`classic`** | classic | name is **`classic`**, not `default`; `-lzxn_clib -lndos`; `z80n_crt0` |
| `new` | newlib | sccz80 |
| `sdcc_ix` / `sdcc_iy` | newlib | both use **`lib/clibs/sdcc_ix`** products; IY reserved on `sdcc_iy` |

## Subtypes

| Subtype | Role |
|---------|------|
| `default` / `zxn` / `tap` | Next packaging (`+zxn`) |
| `bin` | `--bin` |
| `sna` / `snx` | snapshots |
| **`nex`** | `.nex` for NextOS / emulators |
| `dot` / `dotx` | esxDOS DOT |
| `dot-n` / `dotx-n` / `dotn` / `dotn-n` | DOT/DOTN + NextOS defines |

Classic disk often needs **`-lesxdos`** (default classic still has ndos stubs).

## Recipes

```text
zcc +zxn -vn hi.c -o hi -create-app                    # newlib sdcc_iy
zcc +zxn -clib=classic -subtype=nex -create-app …
zcc +zxn -clib=new -subtype=nex -create-app …
zcc +zxn -subtype=dot -create-app …
```

## Hardware-facing code

| Need | Where |
|------|--------|
| Next opcodes (`mul de`, `nextreg`, …) | **`cpu-z80n`**, assemble `-mz80n` |
| NextReg / MMU / copper symbols | `include/arch/zxn.h`, `config_zxn.h` |
| Copper program model | **`cpu-z80n`** § Copper + https://wiki.specnext.dev/Copper |

## Agent notes

1. Always **`-mz80n`** for Next-only opcodes (already in OPTIONS).  
2. Float A/B on Next: `math32_z80n` when measuring HW mul.  
3. Related: `cpu-z80n`, `library-newlib`, `tool-appmake`.
