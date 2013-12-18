
XDEF strxfrm_callee

strxfrm_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strxfrm.asm"
