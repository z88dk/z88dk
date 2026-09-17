# ADR 0086 — a dead Game Boy HL restore does not cross a loop back-edge

Status: **Accepted**, default on. `--opt-disable=regcopy-flow` opts out.

## Context

The HL-bus census in `DESIGN_INDEX.md` named register shuffles as a possible
source of the code-density gap. Counting the final assembly, rather than
lowerer trace events, exposed one repeated Game Boy shape:

```asm
    ld de,hl        ; preserve the result while HL addresses its slot
    ld hl,sp+N
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,de        ; restore the result to HL
    inc bc
    jp L_f1_bb_1
L_f1_bb_1:
    ld hl,sp+M     ; replace HL before reading it
```

The store needs the first copy. The restore has no reader on this path. The
existing dead-register-copy filter only looked through labels and comments to
the *next* instruction. It stopped at `inc bc` or the jump.

## Decision

Extend that filter with a narrow Game Boy rule. Starting after `ld hl,de`, it
may pass blank lines, comments, labels, `C_LINE`, and `inc bc` or `dec bc`. It
then requires an unconditional `jp` or `jr` to a local `L_f...` label whose
first real instruction fully replaces HL without reading it. A conditional
branch, a call, an unknown instruction, or a missing target keeps the copy.

The rule runs on rendered text, before branch relaxation and copt. It changes
no register belief in the lowerer. It is Game Boy only because that target
emits the one-way `ld hl,de` restore in quantity and the copy costs two bytes.

The opt-out is separate from `dead-regcopy`, so this one decision can be
measured without disabling the older dead-copy filter. The regression source
`long_ir/regcopyflow.c` produces exactly one deleted restore on Game Boy; its
keep target uses the opt-out. Z80 sp/fp targets check the same C result.

## Limits

This removes one recoverable part of the shuffle count. It does not make the
raw count a saving estimate. On Z80, much of `ex de,hl` belongs to 32-bit
addition: the high half resides in DE, while the carry-taking `adc hl,bc` can
operate only on HL. Those exchanges cannot simply be deleted. A wider
Game Boy copy-flow pass needs a byte-level, branch-aware liveness proof; this
rule deliberately claims only the one back-edge shape above.

Measurements and validation are in
[`80cc-regcopy-flow-2026-09-17.md`](../../../test/suites/80cc-regcopy-flow-2026-09-17.md).
