
XDEF strncpy_callee

strncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strncpy.asm"
