
XDEF stpncpy_callee

stpncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_stpncpy.asm"
