
; void _div_(div_t *d, int numer, int denom)

SECTION code_clib
SECTION code_stdlib

PUBLIC __div_

EXTERN asm__div

__div_:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm__div
