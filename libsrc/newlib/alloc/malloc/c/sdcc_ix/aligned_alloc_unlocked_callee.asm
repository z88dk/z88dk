
; void *aligned_alloc_unlocked_callee(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _aligned_alloc_unlocked_callee

EXTERN asm_aligned_alloc_unlocked

_aligned_alloc_unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_aligned_alloc_unlocked
