
; void *balloc_firstfit(unsigned int queue, unsigned char num)

XDEF balloc_firstfit_callee

balloc_firstfit_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   
   INCLUDE "alloc/balloc/z80/asm_balloc_firstfit.asm"
