
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

XDEF heap_alloc_fixed_callee

heap_alloc_fixed_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed.asm"
