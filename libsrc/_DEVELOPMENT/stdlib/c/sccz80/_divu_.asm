
; void _divu_(divu_t *d, unsigned int numer, unsigned int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _divu_

EXTERN asm__divu

_divu_:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm__divu
