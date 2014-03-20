
; void *heap_alloc(void *heap, size_t size)

XDEF heap_alloc_callee

heap_alloc_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_alloc.asm"
