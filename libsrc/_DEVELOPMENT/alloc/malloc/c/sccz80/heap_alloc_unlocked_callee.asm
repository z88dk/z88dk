
; void *heap_alloc_unlocked(void *heap, size_t size)

SECTION code_alloc_malloc

PUBLIC heap_alloc_unlocked_callee

heap_alloc_unlocked_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_unlocked.asm"
