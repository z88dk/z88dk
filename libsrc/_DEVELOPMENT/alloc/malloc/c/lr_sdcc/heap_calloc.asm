
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

XDEF heap_calloc

heap_calloc:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_heap_calloc.asm"
