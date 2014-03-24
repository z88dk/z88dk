
; void *heap_alloc(void *heap, size_t size)

XDEF heap_alloc

heap_alloc:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc.asm"
