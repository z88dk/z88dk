
; void *heap_alloc(void *heap, size_t size)

XDEF heap_alloc

heap_alloc:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc.asm"
