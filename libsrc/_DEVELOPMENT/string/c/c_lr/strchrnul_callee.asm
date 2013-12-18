
XDEF strchrnul_callee

strchrnul_callee:

   pop hl
   pop bc
   ex (sp),hl

INCLUDE "../../z80/asm_strchrnul.asm"
