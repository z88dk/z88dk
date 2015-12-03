
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC aligned_alloc_unlocked_callee

EXTERN asm_aligned_alloc_unlocked

aligned_alloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_aligned_alloc_unlocked
