
XDEF strcoll_callee

strcoll_callee:

   pop af
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_strcoll.asm"
