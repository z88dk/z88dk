
; void heap_free_unlocked_callee(void *heap, void *p)

SECTION code_alloc_malloc

PUBLIC heap_free_unlocked_callee

heap_free_unlocked_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
