
; void _divu_(divu_t *d, unsigned int numer, unsigned int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __divu_

EXTERN asm__divu

__divu_:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm__divu
