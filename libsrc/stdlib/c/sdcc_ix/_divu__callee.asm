
; void _divu__callee(divu_t *d, unsigned int numer, unsigned int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __divu__callee

EXTERN asm__divu

__divu__callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm__divu
