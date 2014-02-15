
; int memcmp(const void *s1, const void *s2, size_t n)

XDEF memcmp

memcmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_memcmp.asm"
