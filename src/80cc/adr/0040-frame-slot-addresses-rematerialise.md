# ADR 0040 — Frame-slot addresses rematerialise

Status: **Accepted**, default on. `IR_OFF=remat-lea` opts out, byte-identical.

## Context

The address of a local (`&local`) was computed once, spilled to a frame slot and
reloaded at each use. But it is a pure function of two things the compiler
already knows exactly: the slot offset, fixed per function, and `cur_sp_adjust`,
which is tracked. Recomputing is `ld hl,slot_off+cur_sp_adjust; add hl,sp` —
cheaper than the spill-and-reload, identical in fp and sp mode, and it clobbers
only the target pair, with no IX or DE gymnastics.

## Decision

Rematerialise the address at each use (`emit_remat_word`) instead of giving it a
slot. Two exclusions, both load-bearing:

**A `PR_STACK` tenant.** Its value is parked with push/pop, not in a frame slot,
so dropping the slot orphans one half of the pair and shifts every later
sp-relative offset. `irgaps` miscompiled on this.

**ez80 in fp mode.** Its cheap `lea` / `ld hl,(ix+d)` addressing register-homes
LEAs, so per-use recompute in a hot loop is a byte-for-tick loss — interpbench
ez80-fp −27 B but **+4.6 % ticks**. ez80 *sp* keeps rematerialisation, where sp
addressing is dear and it is a pure win: −117 B and −6.6 % ticks.

Store-base LEAs keep their slot.

## Consequences

The `PR_STACK` exclusion used to be spelled `!(IS_808x() || IS_GBZ80())` — the
CPU stood in for the fact, because those CPUs park LEA values. Measuring it
showed that of the 99 LEAs the CPU test excluded, only **6 (8085) and 5 (gbz80)**
are actually parked, so the CPU test cost about 93 sites per CPU.

Asking the real question is both wider *and* safer: it now also protects a
parked LEA on z80 and every other target, which the CPU test never covered. A
standing lesson — when a gate names a CPU, check whether it means a property.
