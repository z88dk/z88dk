
; void *_falloc_(void *p, size_t size)

XDEF __falloc_

__falloc_:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc.asm"
