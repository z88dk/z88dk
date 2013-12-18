
XDEF _div_callee

_div_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

INCLUDE "../../z80/asm__div.asm"
