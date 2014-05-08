
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)

PUBLIC _heap_calloc_unlocked

_heap_calloc_unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc_unlocked.asm"
