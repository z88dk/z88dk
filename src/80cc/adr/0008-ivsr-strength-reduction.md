# ADR 0008 — Induction-variable strength reduction (IVSR) and LFTR

Status: Accepted

## Context

The dominant cost in array/pointer loops is recomputing an element address every
iteration. For `for (i=0; i<n; i++) sum += a[i]`, naive codegen computes
`&a[i] = base + i*sizeof(elem)` from scratch each pass (a shift + add through
HL/DE). A stepped pointer that just advances by the element stride is far cheaper
— and it is what a resident register can then hold across the loop (ADR 0003).

## Decision

`ir_opt_ivsr` (`ir_opt.c`, gated `IR_NO_IVSR`) rewrites derived induction
variables into **stepped pointers**:

- Detect a derived IV `d = base + iv*scale (+K)` inside a loop where `base` is
  loop-invariant and `iv` is a basic IV.
- Create a new pointer vreg `p`, tagged `IR_VREG_INDUCTION` so the allocator's
  BC pool admits it (the one twice-written — init + step — vreg it accepts), and:
  - **pre-header init:** `p = base + K*scale`;
  - **latch step:** `p += stride*scale` (an `inc bc` / `add` that stays BC-clean);
  - rewrite the in-loop uses of `d` to `p`, NOP the original shift/add.
- **LFTR** (linear function test replacement): when the basic IV survives only as
  the loop's step + exit test, rewrite the exit test in terms of `p` and
  eliminate the basic IV entirely.

A **redundant-pointer suppress** heuristic avoids creating a stepped pointer when
the index is independently live and the base is a constant address with a
power-of-2 scale — there, recomputing `base + iv<<k` from the resident index is
cheaper than maintaining a second loop-carried value competing for BC.

IVSR bails where BC residency is unreachable (any width-4 vreg — long ops stage
through BC; `IR_ASM`; non-char `IR_SWITCH`), mirroring the allocator's BC
envelope so it only fires where the stepped pointer can actually live in BC.

## Consequences

- IVSR is the producer that **feeds the BC walking-pointer home** (ADR 0003):
  the stepped pointer it creates is exactly what `pr_bc_propose` keeps resident.
- It is **paired with, not a substitute for, register residency.** IVSR cuts the
  address recompute; residency then keeps the pointer and the accumulator in
  registers. A register-starved loop (pointer + index + accumulator) still needs
  the residency work to place the survivors.
- The suppress heuristic and the BC-reachability bail are load-bearing: without
  them IVSR can create a second loop-carried value that spills and costs more
  than it saves.
