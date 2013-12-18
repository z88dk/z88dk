
XDEF strlcpy_callee

strlcpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strlcpy.asm"
