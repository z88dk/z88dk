---
name: tool-zcc
description: >
  zcc front end: +target compile/assemble/link, -clib, -compiler, -m map, --math32, -create-app. Use for any z88dk build line.
---

# Tool — zcc

| | |
|--|--|
| Binary | `zcc` |
| Help | zcc +<target> -h  (target-specific clib/subtype lists) |
| Wiki (local draft) | `wiki/tools/Tool---zcc.md` |


## Agent essentials

| Need | Flag |
|------|------|
| Quiet | `-vn` |
| See tool chain | `-v` |
| Map for ticks | `-m` |
| App image | `-create-app` |
| Compiler | `-compiler=sccz80\|sdcc\|80cc\|multi\|…` or target default |
| Float | `--math32` / `--math16` / `--math-mbf32` … |
| CPU | often via `-clib=8085` etc.; also `-m8085` where applicable |

Env: `PATH` includes `bin/`, `ZCCCFG=lib/config`.

**Pitfall:** parallel bare `zcc` in one cwd can corrupt shared `zcc_opt.def` — sequential or separate dirs.

`-compiler=multi` compiles each C file with sccz80 and 80cc, then stitches one function body per name. Default metric is static ticks. sdcc clibs are an ABI error. Spec: `src/zcc-multi/zcc-compiler-multi.md`.


## Condensed reference (from wiki / tree)

# Tool — zcc

`zcc` is the front end for compile, assemble, link, and optional appmake.

## Quick start

```text
zcc +cpm -vn hi.c -o hi
zcc +cpm -vn hi.c -o hi -create-app
zcc +cpm -clib=sdcc_iy -vn hi.c -o hi
zcc +zx -h
```

Always pass a **target** (`+name` or `-target=name`). Full learning path: [Getting started](Getting-Started).

## Capability summary

| Area | Behaviour |
|------|-----------|
| Inputs | `.c`, preprocessed C, `.asm` / `.s`, `.o`, `@list.lst` |
| Compilers | `-compiler=sccz80|sdcc|80cc|multi|ez80clang` (see live help) |
| Libraries | `-clib=` recipes from `lib/config/<target>.cfg` |
| Output | linker binary; `-create-app` runs appmake |
| Verbose | `-v` shows every tool command; `-vn` quiet |

`-clib` and `-subtype` lists in help are **target-specific**. The dump below was taken with `zcc +zx -h` on this tree. Run the same command for your target.


## Methodology notes

| Need | zcc usage |
|------|-----------|
| Map for ticks / hotspots | Add **`-m`** (or `-gen-map-file`); pass the `.map` to ticks with `-x` |
| See every tool step | **`-v`** (not `-vn`) |
| Bound performance work | Classic `+test` + `-DTIMER` labels; see [ticks](Tool---ticks) |
| Float libraries | `--math32` (full IEEE main) / `--math16` (half **adjunct**; pair with a main lib for stdio); CPU-specific `.lib` via `ZCC_LIBCPU` |
| Quiet day-to-day | `-vn` |

Same compile line on both sides of an A/B library patch. Delete stale `.bin`/`.map` after installing a new library.

… (full reference: in-tree wiki page and live tool help)


## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
- `-compiler=multi`: `src/zcc-multi/zcc-compiler-multi.md`
