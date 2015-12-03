
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_firstfit

EXTERN l0_balloc_firstfit_callee

_balloc_firstfit:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp l0_balloc_firstfit_callee
