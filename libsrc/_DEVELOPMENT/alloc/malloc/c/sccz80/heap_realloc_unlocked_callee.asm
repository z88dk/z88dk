
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_realloc_unlocked_callee

EXTERN asm_heap_realloc_unlocked

heap_realloc_unlocked_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_heap_realloc_unlocked
