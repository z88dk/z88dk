
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)

PUBLIC heap_realloc_unlocked_callee

heap_realloc_unlocked_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc_unlocked.asm"
