
; void *balloc_firstfit_callee(unsigned int queue, unsigned char num)

SECTION code_alloc_balloc

PUBLIC _balloc_firstfit_callee, l0_balloc_firstfit_callee

_balloc_firstfit_callee:

   pop af
   pop hl
   pop bc
   push af

l0_balloc_firstfit_callee:

   ld a,c

   INCLUDE "alloc/balloc/z80/asm_balloc_firstfit.asm"
