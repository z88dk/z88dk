# ADR 0064 — The accumulator's contention margin is 3x

Status: **Accepted**. `IR_IVACCK=<N>` re-sweeps the threshold.

## Context

The question at this gate is not "is v uncontended" — an accumulator almost
always overlaps something — but "does it beat the best thing it would displace,
**by a wide margin**".

A margin is needed because benefit here is a **cycle** model, and it cannot
arbitrate a register home on its own: it rates `shiftbench`'s `kshift` highest
on the CPU where the home costs **+23 B** and on the CPU where it saves 36.

## The evidence for 3x

Measured benefit:rival for every candidate in the gap, against the per-cell size
and tick outcome of admitting it:

| candidate | ben : rival | verdict | outcome if admitted |
|---|---|---|---|
| `mix_char` | 3.0 / 3.5 | admit | widthbench: ticks faster on **every** cell |
| `sat` | no rival | admit | predbench: **−462 B**, 16/16 cells faster |
| `reg_get` | 2.7 / 2.6 | refuse | bitfieldbench: +7 B z80 fp for −0.15 % ticks |
| `kmul` | 2.3 / 2.7 | refuse | divbench: **+37 B and +4.5 % ticks** |
| `kshift` | 2.3 / 2.3 | refuse | shiftbench: +23 B and +2.1 % ticks |
| `sdiv`, `iir`, `fxdot`, `matrix_compute`, `lex_compute` | 0.6–0.9 | refuse | the rival is worth **more** than the accumulator |

The cut sits between **2.7** (a byte-for-tick trade the allocator has no mandate
to make) and **3.0** (a two-axis win). It is hysteresis, in the same spirit as
the 1.4x eviction margin on the counter yield: a thin win does not justify
displacing a placed value.

## The companion rule: zero is not "free"

When rivals **exist** but the model prices them all at zero, that is not "BC is
free" — it is the model being **blind**. The known case is the ez80 fp row of
`g0_word_cost`, where a slot read is a native `ld hl,(ix+d)` costing the same 2
cycles as `ld l,c; ld h,b`, so `interval_benefit` rates every candidate 0 and
the arbiter's *order*, not merit, decides.

Acting on that zero is how `divbench` ez80 fp took a home worth −1 B and
**+3.4 % ticks**. Same reasoning as the `seen` condition in `IR_BCCALLCOST`:
demand a real gap before displacing anything. Distinguishing the two cases is
why `iv_acc_rival_benefit` reports a **count** as well as a maximum.
