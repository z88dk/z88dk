
; void *malloc(size_t size)

XDEF _malloc

_malloc:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_malloc.asm"
