
; void *heap_alloc_aligned(void *heap, size_t alignment, size_t size)

XDEF _heap_alloc_aligned

_heap_alloc_aligned:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned.asm"
