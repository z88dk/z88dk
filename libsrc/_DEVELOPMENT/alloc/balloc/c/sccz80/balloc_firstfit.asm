
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_firstfit

EXTERN l0_balloc_firstfit_callee

balloc_firstfit:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp l0_balloc_firstfit_callee
