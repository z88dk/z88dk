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
2. Do not assume sccz80 or sdcc runtime helpers match 80cc output.
3. Prefer reading `src/80cc` notes for current status before large work.

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

- `tool/zcc`, `tool/copt`
