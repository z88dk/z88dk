
; void *heap_calloc_unlocked_callee(void *heap, size_t nmemb, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_calloc_unlocked_callee

_heap_calloc_unlocked_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc_unlocked.asm"
