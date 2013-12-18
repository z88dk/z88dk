
XDEF memchr_callee

memchr_callee:

   pop hl
   pop bc
   pop de
   ld a,e
   ex (sp),hl

INCLUDE "../../z80/asm_memchr.asm"
