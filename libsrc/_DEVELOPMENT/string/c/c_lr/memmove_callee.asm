
XDEF memmove_callee

memmove_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_memmove.asm"
