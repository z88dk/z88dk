
; void *aligned_alloc_unlocked(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC aligned_alloc_unlocked

EXTERN asm_aligned_alloc_unlocked

aligned_alloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_aligned_alloc_unlocked
