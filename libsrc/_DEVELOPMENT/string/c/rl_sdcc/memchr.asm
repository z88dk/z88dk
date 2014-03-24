
; void *memchr(const void *s, int c, size_t n)

XDEF memchr

memchr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld a,e

   INCLUDE "string/z80/asm_memchr.asm"
