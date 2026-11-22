---
name: target-cpm
description: >
  z88dk +cpm only: classic vs newlib CP/M, clib/CPU variants (8080/8085/z180),
  subtypes as packaging (not “newlib”), FCB disk, .com builds. Use when the
  task is explicitly +cpm / CP/M, not generic targets.
---

# Target — CP/M (`+cpm`)

| | |
|--|--|
| Config | `lib/config/cpm.cfg` |
| Tree | `libsrc/target/cpm/` (classic + newlib share tree; **list isolation**) |
| Wiki | `wiki/platforms/Platform---CPM.md` |
| Help | `zcc +cpm -h` (authoritative subtype list) |

## Two worlds (do not mix cores)

| | Classic | Newlib |
|--|---------|--------|
| Select | default / `-clib=default` / `8080` / `8085` / `z180` / `ixiy` / `ansi` | `-clib=new` / `sdcc_ix` / `sdcc_iy` |
| CRT | `lib/target/cpm/classic/cpm_crt0` | `libsrc/target/cpm/cpm_crt.asm.m4` |
| Lib | `-lcpm_clib`, `-lcpm8085_clib`, … | `-lcpm` + sccz80/sdcc_ix clibs |
| Headers | `include/` | `include/_DEVELOPMENT/common/` |
| Disk | classic FCB fcntl | newlib FCB (`asm_target_open_*`); FatFs separate optional stack |
| CPUs | multi (Z80, 8080, 8085, Z180, …) | **Z80-class only** |

**Hard rule:** one `open` owner per binary. Do not link classic fcntl with newlib `cpm_01_file`. See `libsrc/target/cpm/README-mixed-tree.md`.

## Subtypes

- Mostly **disc / packaging** (`-Cz+cpmdisk`, `.com`), **not** “newlib selector”.
- Default subtype → `.com`-style (`-Cz+newext … .com`).
- Some subtypes **force** CPU/clib (e.g. 8080 machines, `bondwell2` → ixiy). Read the subtype line in `cpm.cfg`.
- Suites: prefer **default** subtype only unless a specific machine is in scope (`library-newlib` / `methodology-measure`).

## Recipes

```text
zcc +cpm -vn hi.c -o hi -create-app              # classic Z80 → .com
zcc +cpm -clib=8085 -vn hi.c -o hi -create-app
zcc +cpm -clib=new -vn hi.c -o hi
zcc +cpm -clib=sdcc_iy -vn hi.c -o hi -create-app
zcc +cpm -clib=8085 --math32 …                   # math32_8085 via ZCC_LIBCPU
```

## Agent checklist

1. Confirm **classic vs newlib** before editing CRT/stdio/fcntl.  
2. 8085 CP/M is **classic** — no newlib product.  
3. Do not fan out 100+ subtypes in tests.  
4. Related skills: `library-classic`, `library-newlib`, `cpu-8085`, `tool-appmake`.
