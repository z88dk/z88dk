
; void *memset(void *s, int c, size_t n)

XDEF memset

memset:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "string/z80/asm_memset.asm"
