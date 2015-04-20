
; void *memrchr_callee(const void *s, int c, size_t n)

SECTION code_string

PUBLIC _memrchr_callee, l0_memrchr_callee

_memrchr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_memrchr_callee:

   ld a,e
   
   INCLUDE "string/z80/asm_memrchr.asm"
