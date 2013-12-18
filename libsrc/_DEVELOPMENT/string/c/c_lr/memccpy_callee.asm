
XDEF memccpy_callee

memccpy_callee:

   pop hl
   pop bc
   pop de
   ld a,e
   pop de
   ex (sp),hl
   ex de,hl

INCLUDE "../../z80/asm_memccpy.asm"
