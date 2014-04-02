
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

XDEF _heap_alloc_fixed

_heap_alloc_fixed:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed.asm"
