
XDEF ba_addmem_callee

ba_addmem_callee:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   push af

   ld a,ixl

INCLUDE "../../z80/asm_ba_addmem.asm"
