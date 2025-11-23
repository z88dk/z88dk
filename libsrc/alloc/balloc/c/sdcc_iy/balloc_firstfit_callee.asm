
; void *balloc_firstfit_callee(unsigned char queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_firstfit_callee

EXTERN asm_balloc_firstfit

_balloc_firstfit_callee:

   pop hl
   ex (sp),hl

   jp asm_balloc_firstfit
