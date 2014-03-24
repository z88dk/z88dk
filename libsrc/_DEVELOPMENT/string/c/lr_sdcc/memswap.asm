
; void *memswap(void *s1, void *s2, size_t n)

XDEF memswap

memswap:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "string/z80/asm_memswap.asm"
