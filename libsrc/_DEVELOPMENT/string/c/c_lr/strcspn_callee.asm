
XDEF strcspn_callee

strcspn_callee:

   pop hl
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_strcspn.asm"
