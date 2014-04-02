
; int memcmp(const void *s1, const void *s2, size_t n)

XDEF _memcmp

_memcmp:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_memcmp.asm"
