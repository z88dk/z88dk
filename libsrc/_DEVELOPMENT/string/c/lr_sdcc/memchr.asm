
; void *memchr(const void *s, int c, size_t n)

XDEF memchr

memchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld a,e

   INCLUDE "../../z80/asm_memchr.asm"
