# ADR 0035 — The allocator scores claims independently

Status: Accepted (a finding, 2026-09-14)

Explains why ADR 0021 and ADR 0028 were refused, and what has to change before
either can be reconsidered.

## Context

Two independent attempts to make the allocator's cost model *more correct* made
the emitted code *worse*:

| | The correction | Result |
| --- | --- | --- |
| ADR 0021 | per-value spill heuristics | two identical counters have opposite optimal placements |
| ADR 0028 | true loop trip counts instead of `4^depth` | +845 bytes **and** +0.066 % ticks |

In both cases the number being fixed was genuinely wrong. The weight really is
off by 10x to 100x, in one direction. The fix was sound. The outcome was worse.

## The finding

The allocator scores each candidate **in isolation**. It does not price the
claim that a decision *displaces*.

So when two candidates are close, the winner is settled by pass order rather
than by cost — and feeding the comparison a more accurate number does not
sharpen it, it just re-rolls which side of the tie a value lands on.

The clearest evidence is one benchmark under ADR 0028. `hashbench` is among
the **worst** regressions on one CPU and frame mode (+2.47 %) and among the
**best** improvements on another (−1.29 %). The same source, the same
transformation, moving both ways. That is not a model getting sharper.

**Until the resolver compares competing claims, improving any single cost input
is as likely to hurt as to help.** Therefore, the realised-cost ledger —
scoring each `(vreg, home, window)` claim *including the opportunity cost of what
it displaces* — gates that work rather than competing with it.

## The diagnostic trap

"Truer cost, worse result" has **at least two causes**, and they look identical
from the outside.

The second is not a model limitation but a bug: a register is freed by a failed
home and then offered to nobody. That is what happened with the gbz80 cost row
(ADR 0032) — a value took BC, the lowerer could not realise the home,
`[home-demote]` dropped it to a slot, and the arbiter never ran again to
re-offer the register. Correcting the cost row looked like it had flipped a
ranking tie. Completing the recovery (`[home-rearb]`) made the benchmark neutral
and the correction shipped.

**Rule out the recovery bug first.** It is cheap to check and it is a defect;
the isolation limit is expensive to fix and is a design property.

## Investigated 2026-09-14 — the cost exists, but its input is unknown

The BC pack already performs an opportunity-cost comparison. `bc-evict` computes
the benefit of the tenants it would displace against the benefit of what it
could then place, and evicts only when the gain strictly exceeds the loss. The
structure this ADR asks for is there.

On the `md5/MD5Init` test case it still gets the choice wrong. The reason is
than "no term":

    LEDGER MD5Init  generic: evict=13 gain=20 -> EVICT
                    grounded: evict=230 gain=390 -> EVICT

Both cost systems agree. The generic `COST_*_W` weights and the g0-grounded
`interval_benefit_x`. So it is **not** a units problem. Both under-price the
incumbent for the same reason: they price its fallback as an ordinary frame-slot
read.

The incumbent is a `PARAM_IN_PLACE` whose slot is the **caller's** frame. In a
framed function that read is `ld hl,(ix+d)` — one instruction. In a **frameless**
function it is `ld hl,N; add hl,sp; ld a,(hl+); ld h,(hl); ld l,a` — five. The
param is read six times, so the model under-prices keeping it in BC by roughly
five times, and eviction looks profitable when it costs 29 bytes.

**`ir_alloc.c` does not know about framelessness.** It has zero references. The
lowerer decides the mode after allocation.

And the eviction does not merely make the reads dearer: it **flips the mode**.
Measured on the test case, `frameless` goes 1 -> 0 when the param loses BC, with
`frame_size == 0` in both cases. So the claim also costs the function its frame
apparatus — a second term, likewise unpriced.

## The feedback loop

This cannot be fixed by adding a frame-mode term to the allocator's cost model,
because the frame mode is not an input to allocation — it is an *output* of it.
`frameless_ok` requires **every parameter to be homed in BC**. So:

    allocation decides the param's home
      -> which decides whether the function can be frameless
        -> which decides what the param's slot access costs
          -> which is the number allocation needed to make the first decision.

The realised-cost ledger therefore has a design constraint:
some access costs are not knowable when the claim is scored.

One simplification makes this tractable. **Frameless implies `frame_size == 0`**,
so a frameless function has no local slots at all — only its parameters live in
memory, in the caller's frame. Therefore the two modes price *only parameter
claims* differently; every other claim scores the same either way. The pair is
needed for a small set, and the mode flip is detectable after the fact
(`frameless_ok` is a pure function of the allocation).

Use a bounded repeat rather than a redesign. Allocate, ask
`frameless_ok` what mode resulted, and if it differs from what the parameter
claims were scored against, re-score those claims and re-run the BC arbitration.
`IR_SPFLIP` already establishes the precedent of lowering, measuring, and
re-deciding, and `ir_clone_func` exists for it.

The structural alternative is already available in the lowerer. Route every
frame access through sp when frameless, so `frameless_ok` stops requiring BC
parameter homes and the mode becomes knowable before allocation. That removes
the circularity at its root — and it would also close the latent frameless/fp
landmine in ADR 0031's history — but it is roughly 70 unguarded
`frame_reg()` sites, against 21 that carry the guard today.

`IR_LEDGER` is the inert probe that produced the numbers above: it prints both
denominations of the evict decision side by side. Keep it until the ledger
lands.

## Reopening

Not applicable — this records a property of the current resolver, and it stops
being true when the ledger lands. At that point re-measure ADR 0021 and ADR 0028
rather than redesigning them: both implementations were sound, and it was the
consumer of their output that could not use it.
