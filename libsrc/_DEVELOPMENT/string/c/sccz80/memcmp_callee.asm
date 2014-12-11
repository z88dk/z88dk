
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_string

PUBLIC memcmp_callee

memcmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_memcmp.asm"
