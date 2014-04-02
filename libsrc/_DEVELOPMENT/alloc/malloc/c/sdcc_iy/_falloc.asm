
; void *_falloc(void *p, size_t size)

XDEF __falloc

__falloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc.asm"
