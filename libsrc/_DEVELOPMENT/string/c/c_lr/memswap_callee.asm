
XDEF memswap_callee

memswap_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_memswap.asm"
