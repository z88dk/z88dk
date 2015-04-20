
; void *memchr_callee(const void *s, int c, size_t n)

SECTION code_string

PUBLIC _memchr_callee, l0_memchr_callee

_memchr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_memchr_callee:

   ld a,e

   INCLUDE "string/z80/asm_memchr.asm"
