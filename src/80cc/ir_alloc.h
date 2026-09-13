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

/* The word DE-home pick can only be judged by the render: if no resident
   region forms, the lowerer REJECTS it and the allocator reverts its own plan
   from a snapshot it never hands out. Call _done either way to release it. */
int  ir_alloc_word_home_picked(void);
void ir_alloc_word_home_reject(Func *f);
void ir_alloc_word_home_done(void);

/* [home-demote] Drop v to a frame slot after the render proved its register
   home unrealizable, clearing the flags that would suppress the slot. Returns
   0 if v is out of range. The lowerer reports the vreg; the plan is edited
   here. Pair it with ir_alloc_veto_add so a re-arbitration offers the freed
   register to the next candidate. */
int ir_alloc_demote_home(Func *f, int v);

/* [home-rearb] The lowerer proved a register home unrealizable: veto the value
   so a re-run of ir_alloc offers its register to the next candidate instead of
   leaving it unused. Reset per function. */
void ir_alloc_veto_reset(void);
void ir_alloc_veto_add(int vreg);

/* Does v need a frame slot backing its home? THE allocation answer, and the
   only one — ir_slots asks this instead of re-deriving the rules, and the
   lowerer's lazy-spill asks ir_home_reg_is_slotbacked for the register half of
   it. A register home does not by itself mean "no slot": a clobberable home is
   spilled and reloaded around the ops that clobber it, and a call-split value
   keeps its slot as its canonical home outside the split span. */
int ir_home_requires_slot(const Func *f, int v);

/* Is a byte/word home in this register clobberable, so that it needs a backing
   slot the lowerer can lazy-spill to? E and D are (DE is scratch); C and B are
   not (the no-clobber envelope keeps them resident for the whole function). */
int ir_home_reg_is_slotbacked(PhysReg pr);

#endif /* IR_ALLOC_H */
