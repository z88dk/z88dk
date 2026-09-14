# ADR 0032 — The measured gbz80 cost row

Status: Accepted (shipped default-on; the gate that held it back is removed)

Relates to ADR 0006 (multi-CPU retargeting) and ADR 0003 (residency).

## Context

The allocator prices a frame-slot access and a register access per CPU. gbz80
was using the **Z80 numbers**, which do not describe it. Two rows are wrong, and
both are plain hardware facts rather than tuning preferences:

- **SLOT.** `ld hl,sp+n` makes a gbz80 stack slot about 30 % cheaper than the
  Z80 row claims.
- **PAIR (BC).** A general-pair dereference costs about 16, not 7, because gbz80
  has neither `ld a,(bc)` nor `ex de,hl`.

This matters more on gbz80 than anywhere else: it is the worst-performing target
in the corpus, so it is where future work will concentrate — and every decision
that work makes is priced by this table.

## Decision

Ship both corrections. `IR_GBZ80_MASK` selects which measured rows are used
(bit 0 SLOT, bit 1 BC, bit 2 DE, bit 3 IX/IY) and **defaults to 3** — SLOT and
BC, which is the whole of the effect.

Swept over all sixteen combinations on the gbz80 corpus, both frame modes:

| mask | corpus |
| --- | --- |
| 0 (Z80 row) | 72,308 B |
| 1 (SLOT only) | 72,276 B |
| 2 (BC alone) | worse — one bench +8 B |
| **3 (SLOT+BC)** | **72,204 B** — identical to mask 15 |

The DE and IX/IY rows change nothing in any combination, so the mask stops at 3
rather than 15 to say exactly which rows are load-bearing.

## Why it was held back, and what the delay actually taught

For a long time mask 3 cost one benchmark **+10.38 % ticks**, and that kept the
correction out. The obvious reading was a cost-model problem: two candidates
near a tie, and a truer number tipping the wrong one.

**That reading was wrong, and the distinction matters.** What happened was:
a value took BC, the lowerer could not realise that home, `[home-demote]`
dropped it to a slot — and the register it vacated was then offered to nobody,
because the arbiter never ran again. The cost model was right both times. The
recovery was incomplete.

Once `[home-rearb]` completed that recovery by re-running allocation with the
unrealisable value vetoed, the benchmark went neutral and mask 3 became **−92 B
against mask 1, with 8 tick cells faster and none slower.**

So the lesson is diagnostic: **a regression that appears when you correct a cost
number is not automatically a ranking problem.** Here it was a register going
unused after a failed home — which looks identical from the outside (a truer
cost, a worse result) and needs a completely different fix. Check that a
displaced register is re-offered before concluding that the ranking is at fault.

## Consequences

`IR_GBZ80_COST`, the opt-in that carried the full table while it was held back,
is removed: the default mask already delivers the whole win, and the gate was
byte-identical to the default on every bench in both frame modes.

`IR_GBZ80_MASK` stays. It is the bisection tool for the gbz80 work still to
come, and its swept evidence above is what makes the default defensible.
