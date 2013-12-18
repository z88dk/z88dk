
XDEF strncmp_callee

strncmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strncmp.asm"
