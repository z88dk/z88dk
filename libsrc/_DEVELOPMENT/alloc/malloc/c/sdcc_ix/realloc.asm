
; void *realloc(void *p, size_t size)

XDEF _realloc

_realloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_realloc.asm"
