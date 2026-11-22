# ADR 0100 — Call-containing loop counters do not displace call-safe values

Status: **Rejected** (2026-09)

Relates to ADR 0021 (per-value spill heuristics), ADR 0031 (stepped pointer
parameters in BC), and the call-split residency decisions in ADRs 0061 and
0071.

## Context

`while (n--) f(value)` can leave the changing scalar in a frame slot while a
loop-invariant pointer keeps BC. On GBZ80, the scalar then pays a full word
read-modify-write on every iteration, while the pointer is reloaded around the
call anyway. `vtstone.c`'s `rpt()` was the motivating case: the apparent gap
was roughly 10 bytes per iteration versus a register `dec bc`.

The existing stepped-pointer rule is deliberately narrower: a pointer may
ride BC only when it is stepped in place and the function is call-free. Two
diagnostic widenings were tested:

- `IR_BC_STEP_SCALAR` admitted a single-step scalar in a call-free function.
- `IR_BC_STEP_CALL` admitted a single-step scalar or pointer in a function
  containing calls, with the lowerer verifier and home-demotion retry as a
  safety net.

## Decision

Do not promote either widening. The call-free scalar population changed only
`vtstone.c`'s `mod()` function by about 15 bytes. The call-containing probe
was safe after fixing three allocator bugs exposed by the new retry path, but
it was refuted by sizing: 504 corpus cells produced **7 bytes less in total**,
with one cell 11 bytes smaller and one cell 4 bytes larger. Calls invalidate
BC often enough that almost every candidate is demoted again.

The three allocator fixes are retained as general correctness fixes. The two
environment gates remain diagnostic probes only; they are not optimisation
options and are not candidates for default-on behaviour.

This confirms ADR 0021's rule: a loop counter must not win by value kind alone.
The decision has to price the complete displaced claim, call saves, pressure,
and the realised home window.

## Reopening

Reopen only with a different cost model that demonstrates a positive,
pressure-aware population before implementation. A larger textual count of
frame RMWs is not sufficient; the candidate must remain resident across the
call and beat the value it displaces on both frame modes without slower cells.
