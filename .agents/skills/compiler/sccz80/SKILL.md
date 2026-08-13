---
name: compiler-sccz80
description: >
  sccz80 classic C compiler for z88dk: calling conventions, copt peephole path,
  8080/8085/z80 runtime under libsrc/l/sccz80. Use when debugging sccz80 codegen
  or classic -compiler=sccz80 builds.
---

# Compiler — sccz80

Binary: `z88dk-sccz80` (normally via `zcc`). Source: `src/sccz80/`.

## Agent facts

| Topic | Detail |
|-------|--------|
| Default | Many classic targets use sccz80 |
| Peephole | `z88dk-copt` + `lib/z80rules.*` on **compiler output only** |
| Runtime | `libsrc/l/sccz80/` per CPU (`5-z80`, `7-8085`, `8-8080`, …) |
| Inline ints | May load `z80rules.8` — see `tool/copt` |
| Float rewrite | sccz80 may rewrite `1.0f/x` → `inv(x)`; force runtime numerator to hit `fsdiv` |

## Condensed wiki

# Tool — z88dk-sccz80

Native C compiler. Normally invoked through **zcc**, not directly.

## When to use direct invocation

Rare. Prefer `zcc +target …`. Use the binary directly only when debugging the compiler front end.

## Select via zcc

Default for most classic CLIBs and for `-clib=new`. See [Compilers](Compilers).

## Help

```text
Small-C/Plus - z80 Crosscompiler   Version: 25141-6b30e0885e-20260716
(C) 1980-2025 Cain, Van Zandt, Hendrix, Yorston, z88dk
Usage: z88dk-sccz80 [flags] [file]
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
      -doublestr                Store FP constants as strings
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
      -noaltreg                 Try not to use the alternative register set
      -standard-escape-chars    Use standard mappings for \r and \n
      -set-r2l-by-default       Use r->l calling convention by default
      --constseg                =<name> Set the const section name
      --codeseg                 =<name> Set the code section name
      --bssseg                  =<name> Set the bss section name
      --dataseg                 =<name> Set the data section name
      --

… (more in wiki page)


## Related

- `tool/copt`, `tool/zcc`, `library/classic`, `cpu/8085`
