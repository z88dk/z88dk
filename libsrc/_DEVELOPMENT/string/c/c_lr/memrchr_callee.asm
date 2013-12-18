
XDEF memrchr_callee

memrchr_callee:

   pop hl
   pop bc
   pop de
   ld a,e
   ex (sp),hl

INCLUDE "../../z80/asm_memrchr.asm"
