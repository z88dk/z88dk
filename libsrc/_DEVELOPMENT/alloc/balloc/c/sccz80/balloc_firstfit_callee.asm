
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_firstfit_callee, l0_balloc_firstfit_callee

EXTERN asm_balloc_firstfit

balloc_firstfit_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_balloc_firstfit_callee:

   ld a,c
   
   jp asm_balloc_firstfit
