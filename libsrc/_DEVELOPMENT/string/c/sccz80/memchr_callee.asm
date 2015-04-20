
; void *memchr(const void *s, int c, size_t n)

SECTION code_string

PUBLIC memchr_callee, l0_memchr_callee

memchr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_memchr_callee:

   ld a,e
   
   INCLUDE "string/z80/asm_memchr.asm"
