
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

SECTION code_alloc_malloc

PUBLIC aligned_alloc_unlocked_callee

aligned_alloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc_unlocked.asm"
