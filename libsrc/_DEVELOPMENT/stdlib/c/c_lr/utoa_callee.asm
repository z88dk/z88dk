
XDEF utoa_callee

utoa_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

INCLUDE "../../z80/asm_utoa.asm"
