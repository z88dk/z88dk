
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

XDEF heap_calloc

heap_calloc:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"
