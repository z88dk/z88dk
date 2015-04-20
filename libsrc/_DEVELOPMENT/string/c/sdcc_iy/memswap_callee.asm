
; void *memswap_callee(void *s1, void *s2, size_t n)

SECTION code_string

PUBLIC _memswap_callee

_memswap:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_memswap.asm"
