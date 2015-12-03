
; void _div_(div_t *d, int numer, int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC _div_

EXTERN asm__div

_div_:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm__div
