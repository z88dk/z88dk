
; void *heap_realloc(void *heap, void *p, size_t size)

XDEF heap_realloc_callee

heap_realloc_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_realloc.asm"
