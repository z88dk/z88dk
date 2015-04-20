
; int memcmp_callee(const void *s1, const void *s2, size_t n)

SECTION code_string

PUBLIC _memcmp_callee

_memcmp_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_memcmp.asm"
