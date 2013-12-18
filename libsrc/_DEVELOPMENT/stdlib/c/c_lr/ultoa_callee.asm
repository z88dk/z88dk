
XDEF ultoa_callee

ultoa_callee:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_ultoa.asm"
