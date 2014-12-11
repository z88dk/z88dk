
; void _div_(div_t *d, int numer, int denom)

SECTION code_stdlib

PUBLIC __div_

__div_:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "stdlib/z80/asm__div.asm"
