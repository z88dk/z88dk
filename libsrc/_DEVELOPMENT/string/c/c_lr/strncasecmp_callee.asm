
XDEF strncasecmp_callee

strncasecmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strncasecmp.asm"
