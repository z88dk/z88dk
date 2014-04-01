
; void *_falloc(void *p, size_t size)

XDEF _falloc

_falloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc.asm"
