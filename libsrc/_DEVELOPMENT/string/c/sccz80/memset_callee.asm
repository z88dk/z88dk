
; void *memset(void *s, int c, size_t n)

PUBLIC memset_callee

memset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_memset.asm"
