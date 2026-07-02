/*
 * ir_alloc.h — register allocator over {HL, DE, BC} for the IR pipeline.
 *
 * Per IR_DESIGN.md. Assigns each vreg a PhysReg rather than always
 * spilling:
 *   - IR_PR_HL / IR_PR_DE / IR_PR_BC: int-class vreg in this pair.
 *   - IR_PR_DEHL: long vreg occupying both DE and HL.
 *   - IR_PR_A:    byte vreg in the accumulator.
 *   - IR_PR_SPILL: vreg gets a frame slot.
 */

#ifndef IR_ALLOC_H
#define IR_ALLOC_H

#include "ir.h"

/* Populate f->vreg_to_phys for every vreg. Requires that liveness has
   already been computed (ir_compute_liveness). Idempotent — safe to
   call multiple times on the same Func. */
void ir_alloc(Func *f);

/* Hand off (and clear) the allocation snapshot saved just before the word
   DE-home pick, or NULL if no home was picked this function. The lowerer uses
   it to revert the pick when no resident region forms. Caller frees it. */
int *ir_alloc_take_word_home_prepick(void);

#endif /* IR_ALLOC_H */
