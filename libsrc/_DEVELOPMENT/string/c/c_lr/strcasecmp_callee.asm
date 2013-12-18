
XDEF strcasecmp_callee

strcasecmp_callee:

   pop af
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strcasecmp.asm"
