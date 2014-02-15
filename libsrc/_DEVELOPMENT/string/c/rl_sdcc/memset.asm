
; void *memset(void *s, int c, size_t n)

XDEF memset

memset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_memset.asm"
