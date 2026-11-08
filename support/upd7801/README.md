# uPD7801 assembler

A minimal assembler for the uPD7801, the sub-CPU of the Casio FP-1100 (which owns its video RAM).  It is used to build the sub-CPU program in
`libsrc/target/fp1100/allram/sub/`; the generated binaries are checked in there, so building z88dk does not need it.

- `asm7801.py src.s [org]`: assembles `src.s`, writes `src.bin`, prints the labels.  Source: `[label:] MNEMONIC OPERANDS ; comment`, numbers as
  `$hex` or decimal, `ORG`, `DB`, `DW`, and `JR`/`JRE` resolved by the assembler.
- `asm7801_ops.json` is the opcode table, read back once from MAME's `unidasm -arch upd7801` (set `UNIDASM` to rebuild it if the file is missing), so the
  assembler needs nothing else.  Check a result with `unidasm -arch upd7801`.
