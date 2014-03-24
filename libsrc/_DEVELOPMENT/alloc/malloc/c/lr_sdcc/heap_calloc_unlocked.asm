
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)

XDEF heap_calloc_unlocked

heap_calloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc_unlocked.asm"
