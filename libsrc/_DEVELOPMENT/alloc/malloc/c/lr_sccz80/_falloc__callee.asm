
; void *_falloc_(void *p, size_t size)

XDEF _falloc__callee

_falloc__callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "alloc/malloc/z80/asm__falloc.asm"
