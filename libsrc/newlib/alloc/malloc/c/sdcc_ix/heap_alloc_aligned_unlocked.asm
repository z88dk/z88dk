
; void *heap_alloc_aligned_unlocked(void *heap, size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_alloc_aligned_unlocked

EXTERN asm_heap_alloc_aligned_unlocked

_heap_alloc_aligned_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_heap_alloc_aligned_unlocked
