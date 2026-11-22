
; void *heap_realloc_unlocked_callee(void *heap, void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_realloc_unlocked_callee

EXTERN asm_heap_realloc_unlocked

_heap_realloc_unlocked_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_heap_realloc_unlocked
