
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_firstfit

EXTERN asm_balloc_firstfit

_balloc_firstfit:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_balloc_firstfit
