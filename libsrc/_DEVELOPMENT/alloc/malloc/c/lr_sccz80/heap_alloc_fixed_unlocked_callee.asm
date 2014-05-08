
; void *heap_alloc_fixed_unlocked(void *heap, void *p, size_t size)

PUBLIC heap_alloc_fixed_unlocked_callee

heap_alloc_fixed_unlocked_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed_unlocked.asm"
