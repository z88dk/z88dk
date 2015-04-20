
; void heap_free_unlocked_callee(void *heap, void *p)

SECTION code_alloc_malloc

PUBLIC _heap_free_unlocked_callee

_heap_free_unlocked_callee:

   pop af
   pop de
   pop hl
   push af

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
