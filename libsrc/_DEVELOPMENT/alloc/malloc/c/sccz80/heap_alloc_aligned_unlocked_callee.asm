
; void *heap_alloc_aligned_unlocked(void *heap, size_t alignment, size_t size)

SECTION code_alloc_malloc

PUBLIC heap_alloc_aligned_unlocked_callee

heap_alloc_aligned_unlocked_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned_unlocked.asm"
