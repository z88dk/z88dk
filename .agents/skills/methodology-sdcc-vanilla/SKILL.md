---
name: methodology-sdcc-vanilla
description: >
  Vanilla upstream SDCC (not zsdcc) benchmark recipes: /usr/local/bin/sdcc,
  svn pin vs --version #NNNN, makebin -p, map-sum size, support/benchmarks/*/sdcc.
  Use when remesuring SDCC rows, tagging 4.6.0 #16608, or comparing stock SDCC
  to z88dk-zsdcc. Do not use for -compiler=sdcc / zsdcc patch work.
---

# Methodology — vanilla SDCC benches

**Vanilla SDCC** is stock upstream `sdcc`. It is **not** `bin/z88dk-zsdcc`.

| | Vanilla | zsdcc |
|--|---------|--------|
| Binary | `/usr/local/bin/sdcc` (or PATH `sdcc`) | `bin/z88dk-zsdcc` via `zcc -compiler=sdcc` |
| ABI | `__sdcccall(1)` (stock) | ABI **0** (`src/zsdcc/sdcc-z88dk.patch`) |
| C / float | SDCC’s own | z88dk classic or newlib |
| Published tag | `SDCC 4.6.0 #16608 Linux` | `zsdcc 4.6.0 #16639` |
| Recipes | `support/benchmarks/<bench>/sdcc/readme.txt` | `z88dk-classic/` / `z88dk-new/` |

Never put a vanilla number in a Z88DK/SDCC wiki row. Never put a zsdcc number in an `sdcc/` RESULT block.

zsdcc pin and patch: skill **`compiler-zsdcc`**. TIMER house rules: **`methodology-measure`**.

## Pin vs banner

Upstream checkout is svn **r16639** (4.6.0 final). `ChangeLog` `$Revision$` is often **16608**. `sdcc --version` prints `#16608` unless you patch ChangeLog (do **not** patch a vanilla tree).

Publish the **banner** (`#16608`). In notes you may say “checkout r16639”.

## Host tree

Preferred peer of z88dk: `/data/sdcc` (or `../sdcc` from the z88dk root).

```bash
svn checkout -r 16639 https://svn.code.sf.net/p/sdcc/code/trunk/sdcc /data/sdcc
```

Configure with unused ports off. **`--disable-f8-port` leaves f8l on.** Also pass `--disable-f8l-port` or the build asks for `sdasf8`.

**Do not apply** `src/zsdcc/sdcc-z88dk.patch` to this tree. After a patch dry-run, revert:

```bash
svn revert -R ChangeLog src/SDCCasm.c src/SDCCglue.c src/SDCCmain.c \
  src/SDCCopt.c src/z80/main.c src/z80/peep.c
```

Keyword-only `ChangeLog` may need a check that `$Revision$` is back to 16608.

## Compile and size

From each `sdcc/readme.txt` (z80):

```bash
sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 foo.c -o foo.ihx
makebin -p foo.ihx foo.bin
```

`makebin -p` needs the **output** path. Do not use `hex2bin`.

TIMER labels are `__asm__("TIMER_START:");`. The optimiser warns `z80instructionSize()`; ignore that.

**Size** = sum of map sections in that readme (CODE + HEADER* + …). It is not the z88dk `.bin` “bytes less page zero” rule.

**Ticks:** `z88dk-ticks -mz80 foo.bin -start <hex> -end <hex> -counter 999999999999`. Resolve addresses from `.sym` / `.map` as the readme shows. CPU flag **before** the binary.

## Publish

- Update `sdcc/readme.txt` RESULT and the parent summary row for **SDCC** (not Z88DK/SDCC).
- Date the block. Tag `SDCC 4.6.0 #16608 Linux` (or the live banner).
- Wiki `Benchmarks.md` SDCC rows only. No vanilla SDCC in `Classic--Maths-Libraries.md`.
- Do not stage `wiki-*.md`.

## Known traps

| Item | Action |
|------|--------|
| `sort-equ-5000` | Stock K&R qsort on equals is O(n²). May not finish. Publish “did not finish”. Do not hang ticks for hours. |
| Equals / ordered 20 | Still publish if they complete. |
| 4.6.0 vs 4.2.0 | Vanilla 4.6.0 is often slower on float/long than old 4.2.0 archive rows. Replace the archive row. Do not keep both. |
| hung `z88dk-ticks` | Wrong CPU flag, or counter too small. Kill the process. |

## Related

- `compiler-zsdcc`, `methodology-measure`, `tool-ticks`
- Product recipes: `support/benchmarks/*/sdcc/readme.txt`
