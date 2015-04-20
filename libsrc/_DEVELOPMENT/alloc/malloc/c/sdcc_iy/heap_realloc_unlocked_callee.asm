
; void *heap_realloc_unlocked_callee(void *heap, void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_realloc_unlocked_callee

_heap_realloc_unlocked_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc_unlocked.asm"
