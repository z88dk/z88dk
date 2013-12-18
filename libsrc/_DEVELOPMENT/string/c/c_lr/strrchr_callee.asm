
XDEF strrchr_callee

strrchr_callee:

   pop hl
   pop bc
   ex (sp),hl

INCLUDE "../../z80/asm_strrchr.asm"
