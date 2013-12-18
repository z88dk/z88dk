
XDEF memcmp_callee

memcmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

INCLUDE "../../z80/asm_memcmp.asm"
