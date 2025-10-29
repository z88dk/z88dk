
; void *heap_calloc_unlocked_callee(void *heap, size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_calloc_unlocked_callee

EXTERN asm_heap_calloc_unlocked

_heap_calloc_unlocked_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_heap_calloc_unlocked
