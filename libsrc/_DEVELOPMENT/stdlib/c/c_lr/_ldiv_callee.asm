
XDEF _ldiv_callee

_ldiv_callee:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop bc
   push af

INCLUDE "../../z80/asm__ldiv.asm"
