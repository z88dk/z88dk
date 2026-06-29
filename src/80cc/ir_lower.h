/*
 * ir_lower.h — IR → asm lowerer.
 *
 * Phase 1: dumb spill-everything lowerer. Every vreg lives in a frame
 * slot. Each op loads its operands from frame, computes in HL/DE, stores
 * the result back. No register allocation, no peepholes.
 *
 * Output goes to a FILE* (typically the same asm-output stream the rest
 * of the compiler writes to). The lowerer doesn't depend on codegen.c's
 * global emit machinery — for the prototype it emits directly via
 * fprintf. Later phases may rewire to the existing helpers once we have
 * an allocator providing PhysReg choices.
 *
 * Z80 only in Phase 1. Other CPUs (gbz80 / r2ka / 8085 / kc160 / ez80)
 * land as the lowerer gets per-op CPU-dispatch in later phases.
 */

#ifndef IR_LOWER_H
#define IR_LOWER_H

#include "ir.h"
#include <stdio.h>

/* Lower a function. Returns 0 on success, -1 on failure (writes a
   diagnostic to stderr; the partial output to `out` is left as-is).
   The caller is responsible for opening / closing `out`. */
int ir_lower_func(FILE *out, Func *f);

/* Assign frame slots to all vregs. Sets f->frame_size and
   f->vreg_spill_slot. The dumb lowerer puts every vreg in a slot
   sized to its width, packed back-to-back from sp+0 upward. */
void ir_assign_slots(Func *f);

#endif /* IR_LOWER_H */
