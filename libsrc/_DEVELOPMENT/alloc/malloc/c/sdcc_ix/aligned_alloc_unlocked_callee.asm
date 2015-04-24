
; void *aligned_alloc_unlocked_callee(size_t alignment, size_t size)

SECTION code_alloc_malloc

PUBLIC _aligned_alloc_unlocked_callee

_aligned_alloc_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc_unlocked.asm"
