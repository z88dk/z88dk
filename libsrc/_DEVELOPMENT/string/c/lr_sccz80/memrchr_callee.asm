
; void *memrchr(const void *s, int c, size_t n)

XDEF memrchr_callee

memrchr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ld a,e
   
   INCLUDE "../../z80/asm_memrchr.asm"
