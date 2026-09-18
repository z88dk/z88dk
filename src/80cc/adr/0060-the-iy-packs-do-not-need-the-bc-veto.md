# ADR 0060 — The IY packs do not need the BC veto

Status: **Accepted**, default on. `IR_OFF=iy-long` opts out.

## Context

The whole-function BC veto excludes a function from BC homing when BC cannot be
kept safely across it. The IY packs were being skipped in those same functions,
inheriting a restriction that was never about IY.

## Decision

Run the IY packs regardless of the BC veto. They **self-guard**: each checks
`op_clobbers IR_R_IY` per op over the candidate's live range, so the veto buys
them nothing.

## Note

A gate that names another register's restriction is worth re-reading. This is
the same shape as the CPU-test-standing-in-for-a-property case in ADR 0040, and
the opposite of ADR 0050 where the CPU genuinely is the question: the test must
ask about the thing it actually depends on.
