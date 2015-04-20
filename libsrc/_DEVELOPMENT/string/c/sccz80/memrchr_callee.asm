
; void *memrchr(const void *s, int c, size_t n)

SECTION code_string

PUBLIC memrchr_callee, l0_memrchr_callee

memrchr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_memrchr_callee:

   ld a,e
   
   INCLUDE "string/z80/asm_memrchr.asm"
