
XDEF memmem_callee

memmem_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af

INCLUDE "../../z80/asm_memmem.asm"
