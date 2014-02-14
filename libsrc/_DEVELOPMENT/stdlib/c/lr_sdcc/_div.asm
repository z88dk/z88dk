
; void _div(div_t *d, int numer, int denom)

XDEF _div

_div:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm__div.asm"
