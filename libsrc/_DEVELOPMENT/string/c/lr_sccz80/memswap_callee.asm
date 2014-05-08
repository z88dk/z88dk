
; void *memswap(void *s1, void *s2, size_t n)

PUBLIC memswap_callee

memswap_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_memswap.asm"
