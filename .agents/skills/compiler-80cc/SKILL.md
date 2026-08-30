---
name: compiler-80cc
description: >
  80cc experimental/alternate C compiler in z88dk. Use when -compiler=80cc or
  working under src/80cc.
---

# Compiler — 80cc

Binary: `z88dk-80cc`. Source: `src/80cc/`. Rules file: `lib/80cc_rules.1`.

## Agent facts

1. Select via `zcc -compiler=80cc` when the target allows it.
2. `-compiler=multi` also runs 80cc. It always compiles `80cc-sp`. It compiles `80cc-fp` when 80cc treats the CPU as having IX. Spec: `src/zcc-multi/zcc-compiler-multi.md`.
3. Do not assume sccz80 or sdcc runtime helpers match 80cc output.
4. Prefer reading `src/80cc` notes for current status before large work.
5. Rebuild: `make -C src/80cc PREFIX=$(pwd)` from the z88dk root, then `make -C src/80cc PREFIX=$(pwd) install`.
6. The `--version` / `-h` banner comes from `src/config.h` `Z88DK_VERSION`. That string can be stale after a rebuild. Prove a hunk with `strings bin/z88dk-80cc`, not the banner.

## Frame pointer (Z80 benches)

| Flag | Meaning |
|------|---------|
| `-fframe-pointer` | IX is the frame pointer (`ix+d` locals). Use on **Z80** 80cc TIMER / PRINTF recipes, including `--math-mbf32`. |
| (default) | Omit the frame pointer. Locals via `sp`. IX is a spare index register. |

8085 has no IX. Do not pass `-fframe-pointer` on `-clib=8085`.

Integer benches (sieve, fannkuch) are usually smaller and faster with `-fframe-pointer`. math32 TIMER is usually **slower and larger**: extra time is in 80cc C glue (`ix+d`, byte `add/adc a,(ix+d)`, spills around `l_f32_*`). math32 library cycle counts stay the same. Prove with ticks hotspots rolled up to the C function (`advance`, `selectRandom`), not to `CLIB_*` const symbols.

Recipe comment used in `z88dk-classic/readme.txt`:

```text
# Z80 80cc: -fframe-pointer (IX).
```

## TIMER / correctness

- Classic: `+test -compiler=80cc -DSTATIC -DTIMER -D__Z88DK` (no `PRINTF` for published ticks).
- Some 80cc sources need `__asm__("TIMER_START:");` (same as vanilla SDCC).
- Dhrystone: `-DNOSTRUCTASSIGN`. TIMER is **not** published (Run_Index loop exits in ~800 cycles).
- 80cc+8085 sorting: qsort does not link. Do not invent 8085 80cc sort rows.
- Mandelbrot image: `z88dk-ticks … -output verify.bin` then `z88dk-appmake +extract -b verify.bin -s 0xc000 -l 480 -o image.bin`. Compare to `z88dk-classic/image-golden.bin`. One edge pixel can differ (float). Many last-bytes-of-row (≈15) means missing variable-count byte `<<` (PR #3066).

## PR #3066 (mandelbrot leftover pack)

Not on `master` until merged. Branch `80cc_mandelbrot_pr`.

| Hunk | Role |
|------|------|
| `gen_shl` width-1 + `op->src[1] >= 0` | Count in B, `add a,a` loop. Else `imm` is 0 and the leftover byte is `<< 0`. |
| `gen_ld_mem` `ld a,(bc)` / `(de)` | Gate on `bc_has` / `de_has` (live), not `vreg_in_pr_bc` / `de`. |
| `compound_assign.sh` `ca_char_shl_var` | Expect `00c0`. A lone `zcc +test` of that snippet can print `c0` even without the hunk. Trust the suite or the full mandelbrot image. |

Use `emit_sp` for the BC push/pop. Three-way merge onto current master is clean. Do not cherry-pick only the last commit.

Prove the binary has the fix: `strings bin/z88dk-80cc | rg bshl_loop`.

## Condensed wiki

# Tool — z88dk-80cc

Alternate small-C style compiler. Select with **`-compiler=80cc`** on the zcc line.

## Capability summary

| | |
|--|--|
| Role | A/B codegen vs sccz80; some float benchmarks |
| Not | Full day-to-day replacement for sccz80/zsdcc |
| CPUs | See help (`-m8080`, `-m8085`, `-mz80`, …) |

## Help (live)

```text
80cc - z80 family Crosscompiler   Version: 25141-6b30e0885e-20260716
(C) 1980-2026 Cain, Van Zandt, Hendrix, Yorston, z88dk
Usage: z88dk-80cc [flags] [file]
   -v -verbose                  Be verbose
   -h -help                     Show this help page
   -o -output                   Set the output filename

CPU Targetting:
      -m8080                    Generate output for the i8080
      -m8085                    Generate output for the i8085
      -mez80_z80                Generate output for the ez80 in z80 mode
      -mz80                     Generate output for the z80
      -mz80n                    Generate output for the z80n
      -mz180                    Generate output for the z180
      -mr2ka                    Generate output for the Rabbit 2000A
      -mr3k                     Generate output for the Rabbit 3000
      -mr4k                     Generate output for the Rabbit 4000
      -mr6k                     Generate output for the Rabbit 4000
      -mgbz80                   Generate output for the Gameboy CPU
      -mkc160                   Generate output for the KC160

Code generation options
      -unsigned                 Make all types unsigned
      --disable-builtins        Disable builtin functions
      -params-offset            =<num> Base offset for the function parameters (default: 2)
      -math-z88                 (deprecated) Make FP constants match z88
      -banked-style=regular     Use regular banked calling style
      -banked-style=ti          Use ticalc banked calling style
      -fp-exponent-bias         =<num> FP exponent bias (default: 128)
      -fp-mantissa-size         =<num> FP mantissa size (default: 5 bytes)
      -fp-mode=z80              Use 48 bit doubles
      -fp-mode=ieee             Use 32 bit IEEE doubles
      -fp-mode=mbf32            Use 32 bit Microsoft Binary format
      -fp-mode=mbf40            Use 40 bit Microsoft binary format
      -fp-mode=mbf64            Use 64 bit Microsoft binary format
      -fp-mode=z88              Use 40 bit z88 doubles
      -fp-mode=am9511           Use 32 bit AM9511 doubles
      -standard-escape-chars    Use standard mappings for \r and \n (inert — escapes are always standard)
      -set-r2l-by-default       Use r->l calling convention by default
      --constseg                =<name> Set the const section name
      --codeseg                 =<name> Set the code section name
      --bssseg                  =<name> Set the bss section name
      --dataseg                 =<name> Set the data section name
      --initseg                 =<name> Set the initialisation section name
      -gcline                   Generate C_L

… (more in wiki page)


## Related

- `tool-zcc`, `tool-copt`, `methodology-measure`, `methodology-sdcc-vanilla` (not 80cc)
- Multi selector: `src/zcc-multi/zcc-compiler-multi.md`
