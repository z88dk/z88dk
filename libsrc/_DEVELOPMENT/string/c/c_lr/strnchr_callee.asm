
XDEF strnchr_callee

strnchr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

INCLUDE "../../z80/asm_strnchr.asm"
