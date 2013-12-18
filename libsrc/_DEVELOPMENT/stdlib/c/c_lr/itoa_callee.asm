
XDEF itoa_callee

itoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_itoa.asm"
