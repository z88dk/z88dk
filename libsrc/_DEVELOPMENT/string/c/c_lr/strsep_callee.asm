
XDEF strsep_callee

strsep_callee:

   pop af
   pop de
   pop bc
   push af
   
INCLUDE "../../z80/asm_strsep.asm"

