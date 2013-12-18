
XDEF strcat_callee

strcat_callee:

   pop af
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strcat.asm"
