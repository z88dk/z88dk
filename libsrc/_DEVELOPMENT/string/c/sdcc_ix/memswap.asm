
; void *memswap(void *s1, void *s2, size_t n)

PUBLIC _memswap

_memswap:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_memswap.asm"
