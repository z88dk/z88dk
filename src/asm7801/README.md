# z88dk-asm7801

A minimal assembler for the uPD7801, the sub-CPU of the Casio FP-1100 (which owns its video RAM).  It is used to build the sub-CPU program in
`libsrc/target/fp1100/allram/sub/` (its `Makefile`: `make` there rebuilds the blobs with the installed `z88dk-asm7801`); the generated binaries are checked in there, so building z88dk does not need it.

- `z88dk-asm7801 [-o out.bin] [-Dname=value ...] src.s [org]`: assembles `src.s` and prints the labels (`ADDR NAME`) and the size.  `-Dname=value` replaces
  every word `name` in the source with `value` before it is read (whole words, not after a `$`).  Source: `[label:] MNEMONIC OPERANDS ; comment`,
  numbers as `$hex` or decimal, `a+b` and `a-b`, `ORG`, `DB`, `DW`, and `JR`/`JRE` resolved by the assembler.
- Source directives beyond the instructions: `DEFC name = expr`, `PUBLIC a,b`, `INCLUDE "file"` (beside the including file) and `-Dname=value` (replaces the word `name`).
  They are z80asm's syntax, so one file serves both sides: `-d sub.inc -p SUB_ -U` writes the `PUBLIC` labels as `DEFC SUB_NAME = $addr`, which the
  sub program's loader and the Z80 sources both `INCLUDE`.  `-m` writes a map of all the labels.
- `asm7801_ops.h` is the opcode table, generated once from MAME's `unidasm -arch upd7801` by `gen_ops.py` (set `UNIDASM` if it is not in `~/emu/mame0283-arm64`)
  and checked in: the instruction set will not change.  Check a result with `unidasm -arch upd7801`.
