
; void heap_free(void *heap, void *p)

XDEF _heap_free

_heap_free:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_free.asm"
