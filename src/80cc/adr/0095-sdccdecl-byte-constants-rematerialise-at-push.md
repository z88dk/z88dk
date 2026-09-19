# ADR 0095 — SDCCDECL byte constants rematerialise at the argument push

Status: **Accepted**, default on. `IR_OFF=sdccdecl-byte-const` opts out.

## Context

Annotating `read_reg(type8 i, type8 s)` in the Magnetic emulator with
`__z88dk_sdccdecl` exposed caller-side overhead: its byte arguments were packed
into `push de`, but literal arguments were first narrowed, stored in frame
slots, then reloaded into D/E. The annotated Z80N-fp object used 21,998 B of
`code_compiler`; `do_line_a` alone used 3,943 B.

## Decision

After register allocation, recognize a width-1 value whose every use is as a
byte argument to an SDCCDECL call. Its unique definition may be traced through
MOV and pure width conversions to an immediate. Such a value needs no frame
slot: skip its materialising definition and load the immediate's low byte into
A at the existing stacked-byte argument push. Computed/dynamic values, values
with any other consumer, and ordinary smallc calls keep their existing path.

The recognizer is bounded to eight conversion/copy steps and requires a unique
definition at each step. Every link must also be neither address-taken nor
volatile; its slot may be changed through an alias or require an observable
read. For an adjacent pair of immediate byte arguments, build the packed value
directly with `ld de,nn; push de`; if either argument is dynamic or otherwise
not rematerialisable, keep the existing A-to-D/E sequence. The right-to-left
argument order is unchanged. `sdccdecl-byte-const` is a named default-on opt-out
in the shared `IR_OFF` / `--opt-disable` registry.

## Validation

- `long_ir/sdcccall.c` covers an asymmetric literal byte pair, a mixed
  literal/dynamic pair, and a local changed through a pointer before it is
  passed. The focused runtime suite passes 3/3 on Z80 sp, Z80 fp, and KC160,
  both with the feature on and with its opt-out.
- Full `long_ir` passes 851/851 tests in each frame mode with the feature on;
  the existing `longshl_vm1` assembler gap remains the sole make failure.
- A temporary annotated copy of Magnetic `emu.c` (only `read_reg` decorated)
  compiles for Z80N fp. Its `code_compiler` section is 20,571 B with the
  combined change and 21,998 B with `sdccdecl-byte-const` disabled, a 1,427 B
  reduction. The earlier rematerialisation-only build was 20,813 B, so direct
  pair packing plus keeping HL/A cache state valid saves a further 242 B on
  this case. The original source was not changed.
- The 30-benchmark size scan is unchanged in all 660 CPU/frame cells, and the
  60-cell Z80 tick scan is also unchanged with no slower cells. The standard
  corpus does not exercise this annotated constant-pair shape.
- The enigma, clisp, sorter, fmemopen, and fib console gates passed in both
  frame modes. `adv_a` reached its expected intro but exhausted scripted input
  and continued until the ticks cap; `today.c` remains unbuildable here due to
  existing source errors and was not counted as a pass.
