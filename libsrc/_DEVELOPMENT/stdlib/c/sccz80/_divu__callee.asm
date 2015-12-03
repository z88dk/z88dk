
; void _divu_(divu_t *d, unsigned int numer, unsigned int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _divu__callee

EXTERN asm__divu

_divu__callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm__divu
