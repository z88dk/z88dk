
XDEF strtol_callee

strtol_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_strtol.asm"
