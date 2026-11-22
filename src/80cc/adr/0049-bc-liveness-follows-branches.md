# ADR 0049 — BC liveness follows branches

Status: **Accepted**, default on. `IR_OFF=bc-flow` opts out, byte-identical.

## Context

In the park sweep, every branch was treated as "a successor may read BC", which
keeps a stash alive that the target provably never reads. On `emu.c`, **64 of the
151** surviving `ld bc,hl` reach a branch to a local label.

## Decision

Follow intra-function branches when deciding BC liveness, computing liveness at
each label to a fixpoint. See `bc_live_at_labels()`. ADR 0047 later extended the
same fixpoint to DE, where the ABI makes calls and returns readers.

## Consequences

Corpus **−248 B over 47 cells with zero larger**, every CPU smaller: 8080 −36,
8085 −32, z80/z80n/z180/rabbit/kc160 −24, ez80 −20, gbz80 −16. Real files:
`emu.c` −157 B sp / −149 fp, `clisp` −381, `adv_a` −16.

Ticks −0.0278 % on the z80 corpus, 4 cells faster and 0 slower — it only ever
deletes an instruction, so there is no trade to weigh.

`IR_BCFLOW_DBG=1` reports the label count and how many have BC dead.
