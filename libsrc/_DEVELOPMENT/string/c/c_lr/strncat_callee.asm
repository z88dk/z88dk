
XDEF strncat_callee

strncat_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strncat.asm"
