
; void *heap_alloc_unlocked_callee(void *heap, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_alloc_unlocked_callee

_heap_alloc_unlocked_callee:

   pop af
   pop de
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_unlocked.asm"
