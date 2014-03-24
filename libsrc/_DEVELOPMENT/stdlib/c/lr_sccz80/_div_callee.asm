
; void _div(div_t *d, int numer, int denom)

XDEF _div_callee

_div_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm__div.asm"
