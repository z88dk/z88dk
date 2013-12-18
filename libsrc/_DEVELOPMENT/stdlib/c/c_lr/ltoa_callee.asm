
XDEF ltoa_callee

ltoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_ltoa.asm"
