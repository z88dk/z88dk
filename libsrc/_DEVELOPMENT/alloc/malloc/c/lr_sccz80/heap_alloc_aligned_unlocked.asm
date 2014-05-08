
; void *heap_alloc_aligned_unlocked(void *heap, size_t alignment, size_t size)

PUBLIC heap_alloc_aligned_unlocked

EXTERN asm_heap_alloc_aligned_unlocked

heap_alloc_aligned_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_heap_alloc_aligned_unlocked
