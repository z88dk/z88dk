/*
 * ir_lower.h — IR → asm lowerer.
 *
 * Dumb spill-everything lowerer: every vreg lives in a frame slot;
 * each op loads operands from frame, computes in HL/DE, stores back.
 * No register allocation, no peepholes.
 *
 * Output goes to a FILE* (typically the compiler's asm-output stream).
 * Emits directly via fprintf rather than codegen.c's global machinery.
 *
 * Z80 only; other CPUs (gbz80 / r2ka / 8085 / kc160 / ez80) land once
 * the lowerer gains per-op CPU dispatch.
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

/* True on targets WITHOUT cheap sp-relative addressing (z80/z180/ez80/808x/
   z80n), where the sp+0 pop/push slot trick beats the ld hl,N;add hl,sp walk.
   False on Rabbit/gbz80/kc160 (native sp-rel access + dearer push/pop).
   Exposed so ir_slots' sp0 fastpath shares one definition. */
int tos_pushpop_ok(const Func *f);

#endif /* IR_LOWER_H */
