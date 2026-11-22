
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_calloc_unlocked

EXTERN asm_heap_calloc_unlocked

_heap_calloc_unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_heap_calloc_unlocked
