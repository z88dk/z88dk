
XDEF strspn_callee

strspn_callee:

   pop hl
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_strspn.asm"
