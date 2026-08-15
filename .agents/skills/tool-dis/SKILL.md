---
name: tool-dis
description: >
  z88dk-dis disassembler for binaries/objects. Use to inspect codegen and library expansion.
---

# Tool — dis

| | |
|--|--|
| Binary | `z88dk-dis` |
| Help | bare z88dk-dis usage |
| Wiki (local draft) | `wiki/tools/Tool-z88dk-dis.md` |


Prefer assembler `-l` listings for library sources. Use dis for linked binaries with map context when needed.


## Condensed reference (from wiki / tree)

# Tool — dis (`z88dk-dis`)

Multi-CPU disassembler. Load map/symbol files for named labels. Use with assembler listings when you need to see **expanded** synthetics in library sources.

## Help path

Bare invocation prints usage. Do not assume a uniform `-h`.

```text
z88dk-dis -mz80 program.bin
z88dk-dis -x program.map -o 0x8000 -s 0x8000 program.bin
z88dk-dis -m8085 program.bin
```

Put **`-x` map/symbol** before `-o` / `-s` / `-e` when symbols should apply to those addresses.

## CPU flags

Use the **`-m…`** form (same family as ticks/zcc): `-m8080`, `-m8085`, `-mgbz80`, `-mz80`, `-mz80n`, `-mz180`, Rabbit, kc160, ez80 modes, …

## Methodology

| Goal | Approach |
|------|----------|
| See what linked at an address | `-x prog.map` + start address from the map |
| Check 8085 vs Z80 opcodes | Match `-m` to the binary |
| Verify **synthetics** in a source file | Prefer `z88dk-z80asm -m8085 -l file.asm` and read the `.lis` opcodes (for example `ld a,(de+)` → `1A 13`) |
| Compare two builds | Disassemble the same range in both binaries |

Assembler listing (often clearer for one module):

```text
z88dk-z80asm -m8085 -l -o/tmp/x.o file.asm
# inspect file.lis
```

## Live usage text

```text
z88dk disassembler

z88dk-dis [+target] [options] [file]

  +target        Enable extended disassembly for target
  -x <file>      Symbol file to read
                 Use before -o,-s,-e to enable symbols
  -o <addr>      Address to load code to
  -s <addr>      Address to start disassembling from
  -e <addr>      Address to stop disassembling at

  -k <count>     Skip count bytes in the input file
  -mz80          Disassemble z80 code
  -mz180         Disassemble z180 code
  -mez80_z80     Disassemble ez80 (short) code
  -mez80         Disassemble ez80 ADL code
  -mz80n         Disassemble z80n code
  -mr2ka         Disassemble Rabbit 2000A code
  -mr3k          Disassemble Rabbit 3000 code
  -mr4k          Disassemble Rabbit 4000 code
  -mr5k          Disassemble Rabbit 5000 code
  -mr6k          Disassemble Rabbit 6000 code
  -mr800         Disassemble R800 code
  -mgbz80        Disassemble Gameboy z80 code
  -m8080         Disassemble 8080 code (with z80 mnemonics)
  -m8085         Disassemble 8085 code (with z80 mnemonics)
  -mkc160        Disassemble KC160
  -mkc160_z80    Disassemble KC160 in Z80 mode
```

## Related

- [Tool — ticks](Tool---ticks)
- [Tool — z80asm](Tool---z80asm)
- [Tool — z80nm](Tool---z80nm)

## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
