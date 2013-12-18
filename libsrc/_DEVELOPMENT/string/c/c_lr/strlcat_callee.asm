
XDEF strlcat_callee

strlcat_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_strlcat.asm"
