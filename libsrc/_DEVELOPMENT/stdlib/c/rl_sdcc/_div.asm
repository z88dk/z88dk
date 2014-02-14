
; void _div(div_t *d, int numer, int denom)

XDEF _div

_div:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm__div.asm"
