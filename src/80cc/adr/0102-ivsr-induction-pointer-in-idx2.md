# ADR 0102 — The IVSR induction pointer can use idx2 on ez80/kc160/rabbit

Status: **Accepted**, CPU-gated (ez80/kc160/rabbit only). `idx2-base` opts out
(shared with the pre-existing deref-base idx2 gate).

## Context

80cc already has induction-variable strength reduction (`ir_opt_ivsr` in
`ir_opt.c`). It changes `base + i*scale`, recomputed on each iteration, into a
walking pointer. The pass skipped loops where `i` had other uses because a
second stepped pointer would compete for the BC home. That assumption is too
strong. `idx2_home_realizable` already supports stepped pointers in IX/IY
(ADR 0062), but it rejected this case.

## Decision

`build_idx2_maps` counts an `IR_VREG_INDUCTION` pointer's step/init as real
`cstep`/`cinit` (not `cother`). `idx2_home_realizable` gets a dedicated
`CF_IDX2_INDUCTION` path, checked BEFORE the general `is_base[v]`/counter
dispatch and unconditionally for every induction vreg — a non-deref-base
companion (e.g. LFTR's loop-bound pointer) is step-shaped like a counter but
must not fall through to the general-purpose counter path, which has no CPU
restriction of its own. `ir_opt_ivsr`'s suppression backs off when
`f->idx2_reg != IR_PR_NONE`. CPU-gated to ez80/kc160/rabbit: their 1-op word
slot load and native indexed addressing make a walking pointer in IX/IY pay;
plain z80/z80n/z180/r800 measured a wash or a regression on the same
isolated test case (indexed addressing itself costs more there than the
recompute it replaces).

Three bugs surfaced during development. All were fixed before shipping.

1. `f->idx2_reg != IR_PR_NONE` only proves that the register exists. It does
   not prove that the register is free. A parameter already resident there can
   lose the contention, causing the new candidate to spill.
2. The induction path called `idx2_counter_hostile_use`. That helper handles a
   scalar read through index-register halves, not a pointer dereference.
3. A later rematerialisation pass can turn the preheader's `p = MOV base` into
   a direct copy of base's producer. Therefore, `cinit` matching must accept
   the catch-all case.
4. A CPU-gate bug was found by a corpus diff. The induction branch was nested
   inside `is_base[v]`, so a non-deref-base companion reached the unrestricted
   counter check. `vm1` then changed when it must not. Move the induction check
   before the general counter check and run it for every induction vreg.

## Disclosed regression

`interpbench`/ez80/sp: +12 B, +~4% ticks. Not a contention bug — `vm_run`
only ever proposes one idx2 candidate for the whole function. The real cause
is that candidate's own cost pricing (`idx_ben`) overvaluing it on this
shape: `--opt-disable=idx2-base` removes the regression entirely. A recost
attempt (charging the one-time `push ix`/`pop ix` bracket this candidate's
admission forces, since nothing else in the function needs IX saved) was
built, measured (8T on ez80, matching a direct empty-loop-anchored
measurement), and reverted: even that correctly-measured charge doesn't
close the gap, because the real alternative codegen (a data-stack park) is
cheaper than the cost model's generic SLOT baseline assumes — a mismatch
between the model and the real fallback, not a missing one-time cost. Left
open; shipped as-is, same as any other CPU-gated allocator feature with one
disclosed cell.

## Regression coverage

`long_ir/ivsr_lftr_{ez80,kc160,r4k}[_fp]` (5 targets): the existing
`ivsr_lftr.c` LFTR correctness test, now also run on all three target CPUs —
this is the precise shape of the CPU-gate-escaping bug above (a non-deref
loop-bound companion pointer), confirmed via `IR_RANKDUMP`: on ez80 the
induction vreg is offered both BC and idx2; on vm1 (already covered) only
BC, never idx2.

## Evidence

`long_ir` 523/523 files, 931/931 runs, both frame modes, 0 failures.
`enigma` and the magnetic-emulator behavioural gate pass both modes. Full
corpus `BENCH_MATRIX.txt` refresh: 44 cells changed, all on the
ez80/kc160/rabbit family, zero changes on any other CPU — net
**-495 B / -9.94M ticks**. On an isolated, deliberately uncontended test case
built to measure the ceiling cleanly:

| CPU | ticks | size |
|---|---|---|
| ez80 | 1,070,904 → 674,824 (**-37%**) | 4347 → 4321 B (**-26 B**) |
| kc160 | 766,929 → 623,249 (**-18.7%**) | 3984 → 3980 B (**-4 B**) |
| rabbit (r4k) | 2,024,174 → 1,796,894 (**-11.2%**) | 4178 → 4180 B (+2 B) |

Plain z80/z80n/z180/r800 measured on the same isolated case: 3,242,596 →
3,219,420 ticks (+0.7%), 4398 → 4410 bytes (+12 B) — essentially a wash,
confirming the CPU gate. `vecbench`/`queenbench` were re-run on ez80 with
this patch to check whether it explained either bench's remaining gap
against xcc: it didn't — byte-identical, zero ticks movement on both (both
reach their walking-pointer residency through other, pre-existing
mechanisms, unrelated to this change).
