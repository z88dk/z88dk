
XDEF strstr_callee

strstr_callee:

   pop af
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strstr.asm"
