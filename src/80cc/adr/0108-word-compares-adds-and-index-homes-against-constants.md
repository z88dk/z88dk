# ADR 0108 — Word compares, constant adds and IX/IY-homed words use the shortest form

Status: **Accepted** (2026-10). Opt-outs: `cmp-k-load`, `add-k-reg`,
`idx-step-inc`, `idx-cmp-mem`.

## Context

Four spellings were longer than their alternatives.

- A word compare against a constant with the operand in a frame slot used a
  slot-addressed byte walk.
- A constant added to a word already in BC or DE copied it to HL first:
  `ld hl,bc; ld de,32; add hl,de` is 6 bytes, `ld hl,32; add hl,bc` is 4 and
  leaves the other pair alone.
- A pointer homed in IX/IY stepped by 1 or 2 used `ld de,k; add iy,de`.
- A fused `*a == *b` branch copied an IX/IY-homed pointer to HL to dereference
  it.

## Decision

- `cmp-k-load`: load the operand into HL and subtract the immediate bytes
  through A, on every CPU except the 8085. Not taken when a word home
  (`func_whome` or `de_home`) is active, because HL is then not free.
- `add-k-reg`: `ld hl,K; add hl,bc|de` for a constant that is not a 1..3 inc
  chain, only when the source is cached in BC or DE and not in HL.
- `idx-step-inc`: a step of 1 or 2 on an IX/IY home is `inc`/`dec` of the
  register.
- `idx-cmp-mem`: a fused byte compare reads an IX/IY-homed pointer as
  `cp (iy+0)`; the same operand form lets the other ALU operations take it.
- An IY home placed after a word DE-home pick survives that pick being
  rejected (`alloc_note_late_home`). The lost home was the cause of the
  `hashbench` slowdowns that started this.

## Evidence

`cmp-k-load` -401 B over the corpus, -384 B / -141 B on the console programs.
`add-k-reg` -166 B over the corpus. Tests: `cmpkload.c`, `addkreg.c`,
`idxstep.c` (each on 8 CPU/mode variants).

## Tried and refused

Raising the IY accumulator score threshold so fewer words take IY: +1089 to
+1664 B over the corpus. The cost is not in how often IY is chosen.

## Reopen if

z80asm stops synthesising `ld iy,(ix+d)` on plain Z80 (see the index-synthetics
note); several of the IY forms are gated to avoid it.
