---
name: compiler-zsdcc
description: >
  zsdcc (SDCC-based) compiler path in z88dk: -clib=sdcc_ix / sdcc_iy, newlib
  integration. Use when building with SDCC or debugging sdcc calling conventions.
---

# Compiler — zsdcc

Binary: `z88dk-zsdcc` (via `zcc -compiler=sdcc` or target `-clib=sdcc_*`).
Patches/notes: `src/zsdcc/`.

## Agent facts

| Topic | Detail |
|-------|--------|
| Common clibs | `sdcc_ix`, `sdcc_iy` (IY reserved in many newlib configs) |
| World | Prefer **newlib** (`-clib=new` / sdcc clibs), not classic 8085 |
| Calling | Do not mix sccz80 and sdcc objects carelessly |
| Opts | SDCC-specific peephole rules under `lib/sdcc/` |

## Condensed wiki

# Tool — z88dk-zsdcc

Patched **SDCC** used by z88dk. You rarely call this binary by hand. Select it through zcc CLIB recipes.

## Version (this tree)

| Item | Value |
|------|--------|
| SDCC baseline | **4.5.0 r15248** (`changelog.txt` v2.4) |
| Patch for that revision | `src/zsdcc/sdcc-15248-z88dk.patch` |
| Readme also names | `sdcc-z88dk.patch` as the current default standard patch file |
| Preprocessor | **ucpp** (switched in v2.3) |

Install: nightly builds for Windows/macOS include zsdcc. Linux builds use `BUILD_SDCC=1` / installation wiki.

## Select via zcc

| Flag | Meaning |
|------|---------|
| `-clib=sdcc_iy` | Preferred on many targets; adds `--reserve-regs-iy` |
| `-clib=sdcc_ix` | SDCC with IX frame conventions as defined by cfg |

Example (verified on `+cpm`):

```text
zcc +cpm -clib=sdcc_iy -vn hi.c -o hi
```

## Limits

- Intended for **Z80-class** work in this toolchain.
- For **8080 / 8085 / gbz80** classic products, prefer **sccz80** (or 80cc), not zsdcc.
- Library directory is often still `lib/clibs/sdcc_ix` even for `sdcc_iy`. Read `lib/config/<target>.cfg`.

## Related

- [Compilers](Compilers)
- [Tool — zcc](Tool---zcc)
- `src/zsdcc/readme.md`

## Related

- `library-newlib`, `tool-zcc`, wiki `learning/Compilers.md`
