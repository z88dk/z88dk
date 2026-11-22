# ADR 0122 — A reversed-loop counter bids for BC, then narrows if it spills

Status: **Accepted**. Gated: `--opt-disable=countdown-word`, `countdown-fp`
and `countdown-b`. With all three off the compiler is byte-identical to the
one before this change.

## Context

Loop reversal turns `for (i = 0; i < N; ++i)` into a private counter that
counts down from N. The body does not read it. The counter has three ops: a
load of N, a `dec`, and the latch branch.

For N up to 255, `ir_opt_narrow_iv` retyped that counter to a byte. Every BC
home in the allocator needs a word, so a byte counter could never take BC. It
always lived in a frame slot. In sp mode the code is `ld hl,k; add hl,sp;
dec (hl)` and a matching init, about 14 bytes for the counter.

## Decision

1. **The counter stays a word through allocation.** `ir_opt_narrow_iv` tags it
   `IR_VREG_CD_COUNTER` instead of narrowing it. The counter then bids for BC
   with the normal arbiter.
2. **A counter that does not end in BC is narrowed afterwards.** At the end of
   `ir_alloc`, a tagged counter that spilled becomes a byte again, exactly as
   before. A counter that landed in any other register (a shadow register, IX,
   IY) is also narrowed, and the function is allocated again. On vm1 the
   shadow-register home made the latch `dec hl'; push hl'; pop hl; ld a,h;
   or l`.
3. **The bid is skipped where the byte slot is cheaper than BC.**
   - gbz80, and ez80 in sp mode. Their stack addressing is cheap, and the
     calls the counter spans cost a `push bc` / `pop bc` pair each.
   - With `-fframe-pointer` on an IX CPU, when the function needs an IX frame
     anyway. The byte slot is `dec (ix+d)`, and BC is worth more elsewhere. If
     the counter is the only reason for a frame, it keeps BC and the frame
     goes.
4. **A BC counter whose value is only ever 1 to 255 lives in B.** The lowerer
   checks that the counter has one `ld K` and one `dec` of itself, and that its
   only uses are that `dec` and the latch. Then the loop is `ld b,K` ...
   `djnz`. On 8080 and vm1 it is `dec b` / `jp nz`. The 8085 keeps its K-flag latch. Any other
   def or use keeps the BC word, because a pair copy would put the high byte,
   0, in B. The existing `push bc` / `pop bc` around calls preserves it.
5. **`djnz` is fused only when it is known to reach.** The lowerer emits
   `dec b ;cdcnt` and `jp nz`. The branch relaxation pass (ADR 0025) turns the
   pair into `djnz` when it already proves the target is in `jr` range. A
   larger body keeps `dec b` and `jp nz`.

A loop whose trip count is the constant 1 is not a loop. `try_reverse_loop`
keeps the body and drops the test, step and back-jump. The index is still set
to its bound after the loop when the source declared it outside the `for`.

## Rejected

**Never narrow the counter** (step 1 without step 2). The two small test loops
got BC, but the corpus lost **+4736 B** over 858 cells (13 CPUs, sp and fp):
126 cells smaller, 494 larger, worst `ptrbench` kc160 fp +51 B. Where BC is
already taken, a word counter in a 2-byte slot costs more than the byte it
replaced. The wider slot also moved every other slot offset. In `strbench` z80
sp the frame grew by 2 bytes and several `jr` went out of range and became
`jp`. Narrowing after allocation is what removes this loss.

To reopen it, the allocator would have to price the counter at its byte
fallback, not at a word slot.

## Consequences

Corpus size scan, last two commits against the same compiler with
`IR_OFF=countdown-word`: **-652 B**, 68 cells smaller, 3 larger (Rabbit
`intbench`, +1, +1, +2). Decisions 1 to 3 alone were -374 B, 63 smaller, 10 larger;
decisions 4 and 5 added -278 B and no larger cell.

Ticks, z80, 8080, r2ka, ez80_z80, kc160 and gbz80, sp and fp, 396 cells: 23
faster, 6 slower, no failure, geometric mean 0.99999. The largest slowdown is
+0.026 %.

A tagged counter now competes for BC. It can take BC from a tenant that the
arbiter ranks lower, so a function can change in a way that is not a saving.
The scan found no such cell larger than 2 bytes.

The call-split and call-cost rules already decide whether BC pays across calls
(`bc-call-cost`). A loop body with many calls keeps the byte counter.

## Tests

`test/suites/long_ir/tripone.c` — constant trip count 1: with a call, the index
after the loop, `continue`, a `for (int j ...)` declaration, a non-zero start.

`test/suites/long_ir/cdcount.c` — a counter live across one and two calls,
counts of 4, 255 and 256, nested loops, a pointer and a long beside the
counter, the index after the loop, and a body longer than `djnz` can reach. Both run on z80, fp, 8080, 8085, gbz80, r2ka, r4k, z180, ez80 and kc160.
