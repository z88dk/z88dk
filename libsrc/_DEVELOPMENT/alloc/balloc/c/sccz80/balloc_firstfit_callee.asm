
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION seg_code_balloc

PUBLIC balloc_firstfit_callee

balloc_firstfit_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld a,c
   
   INCLUDE "alloc/balloc/z80/asm_balloc_firstfit.asm"
