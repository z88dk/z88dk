
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _aligned_alloc_unlocked

EXTERN asm_aligned_alloc_unlocked

_aligned_alloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_aligned_alloc_unlocked
