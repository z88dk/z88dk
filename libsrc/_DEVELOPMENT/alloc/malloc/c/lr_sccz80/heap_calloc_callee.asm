
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

XDEF heap_calloc_callee

heap_calloc_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_heap_calloc.asm"
