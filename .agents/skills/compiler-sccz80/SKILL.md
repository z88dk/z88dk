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
| Peephole | `z88dk-copt` + `lib/sccz80_rules.*` and `lib/z88dk_intrinsic` on **compiler output only** |
| Runtime | `libsrc/l/sccz80/` per CPU (`5-z80`, `7-8085`, `8-8080`, …) |
| Inline ints | May load `sccz80_inline` — see `tool-copt` |
| Float rewrite | sccz80 may rewrite `1.0f/x` → `inv(x)`; force runtime numerator to hit `fsdiv` |
| `-compiler=multi` | sccz80 is the data-variant. Its `dumplits` image is the one file string pool. Do not emit a second pool for a selected function. Matching images use that label and the same offsets. A different image is merged by C string (`i_N+off` through the next NUL). Spec: `src/zcc-multi/zcc-compiler-multi.md` |
| Tests | Extend `test/suites/sccz80/*.c`. Do not add a language or a dependency the tree does not already build, unless the user specifically and explicitly directs it (`AGENTS.md` house rule 8). `declspec.c` is sccz80 only. 80cc still rejects a qualifier before the storage class |
| Architecture | `src/sccz80/sccz80 Architecture Guide.md` is the model to keep. Later work maintains that model |

## Settled model

Keep these. Do not reopen them as a redesign.

- Declaration specifiers may stand in any C90 order. `DeclSpecs` and `parse_type` in `declparse.c` are that reader. One storage class. A repeated class is an error. `const` and `volatile` may follow the type word, and that object is `rodata_compiler`.
- `auto` and `register` are storage only before the type word. After the type word they are names.
- `__critical` is a statement (`docritical` in `stmt.c`) or a trailing function attribute. It is not a declaration specifier. A block calls `l_push_di` then `l_pop_ei`. Rabbit uses `ipset 3` and `ipres`.
- Locals are stack slots from SP. There is no `-frameix` or `-frameiy`. `__z88dk_saveframe` preserves the caller's IX only.
- A struct return is a pointer in HL. There is no hidden result pointer.
- A fastcall argument stays in registers and is not part of the stack cleanup count.
- An integer constant is `int_const_val` (`uint64_t`). `sizeof` parses its operand and does not evaluate it.
- `publish_struct_size` writes a completed struct size back into types parsed while the tag was open.
- Peephole files are `lib/z88dk_intrinsic`, then `lib/sccz80_rules.1`, `.2`, and `.3` as in the architecture guide. The compiler has no peephole pass.

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

- `tool-copt`, `tool-zcc`, `library-classic`, `cpu-8085`
