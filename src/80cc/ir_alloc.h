/*
 * ir_alloc.h — register allocator over {HL, DE, BC} for the IR pipeline.
 *
 * Phase 3 (per IR_DESIGN.md). Replaces the dumb spill-everywhere lowerer's
 * "every vreg has a slot" with a per-vreg PhysReg assignment:
 *   - IR_PR_HL / IR_PR_DE / IR_PR_BC: int-class vreg lives in this pair.
 *   - IR_PR_DEHL: long vreg occupies both DE and HL.
 *   - IR_PR_A: byte vreg lives in accumulator.
 *   - IR_PR_SPILL: vreg gets a frame slot, treated as today.
 *
 * Staging:
 *   Stage 2 (this commit): skeleton. Every vreg → PR_SPILL. The lowerer
 *     keeps its current spill-everywhere behaviour. No perf change.
 *   Stage 3+: real assignment to PR_HL, then PR_DE, then PR_BC, then
 *     aliased-constraint enforcement, then save/restore around calls.
 *
 * Plan in `.tmp/PHASE3_ALLOC_PLAN.md`.
 */

#ifndef IR_ALLOC_H
#define IR_ALLOC_H

#include "ir.h"

/* Populate f->vreg_to_phys for every vreg. Requires that liveness has
   already been computed (ir_compute_liveness). Idempotent — safe to
   call multiple times on the same Func. */
void ir_alloc(Func *f);

#endif /* IR_ALLOC_H */
