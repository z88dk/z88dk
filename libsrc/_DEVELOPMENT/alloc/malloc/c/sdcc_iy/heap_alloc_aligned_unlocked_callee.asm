
; void *heap_alloc_aligned_unlocked_callee(void *heap, size_t alignment, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_alloc_aligned_unlocked_callee

_heap_alloc_aligned_unlocked_callee:

   pop af
   pop de
   pop bc
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned_unlocked.asm"
